import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_task_v1_app/models/task.dart';
import 'package:flutter_task_v1_app/services/supabase_service.dart';

class AddTaskUi extends StatefulWidget {
  const AddTaskUi({super.key});

  @override
  State<AddTaskUi> createState() => _AddTaskUiState();
}

class _AddTaskUiState extends State<AddTaskUi> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whereController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // --- ตัวแปรสำหรับเก็บข้อมูลรูปภาพสำหรับ Web เท่านั้น ---
  Uint8List? _imageBytes;
  XFile? _selectedXFile;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันเลือกรูปภาพ (เหมือนเดิม)
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // อ่านไฟล์ที่เลือกเป็น Bytes
      var f = await image.readAsBytes();
      setState(() {
        _imageBytes = f;
        _selectedXFile = image;
      });
    }
  }

  // ฟังก์ชันเลือกวันที่ (เหมือนเดิม)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Add Task',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --- ช่องโชว์รูปภาพ (เวอร์ชันการันตีไร้ Image.file) ---
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13.0),
                      child: _imageBytes != null
                          // เปลี่ยนมาใช้ Image.memory เพื่อแสดงผล bytes ที่เราดึงมา
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          // ถ้ายังไม่มีรูปให้โชว์ไอคอน + กล้อง
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.green),
                                SizedBox(height: 5),
                                Text('เพิ่มรูปภาพ',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่องาน (Task Name)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title, color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _whereController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'สถานที่ / รายละเอียด',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.location_on, color: Colors.green)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _personController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'จำนวนคน (Persons)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.people, color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'วันที่ครบกำหนด (Due Date)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.green),
                ),
              ),
              const SizedBox(height: 40),

              // ปุ่มบันทึก (getSave Task Button)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  onPressed: _isUploading
                      ? null
                      : () async {
                          if (_nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('กรุณากรอกชื่องานก่อนนะคะ!'),
                                    backgroundColor: Colors.red));
                            return;
                          }

                          setState(() {
                            _isUploading = true;
                          });

                          String imageUrl = '';

                          // อัปโหลดรูปแบบ Bytes ขึ้น Supabase (เรียกใช้ uploadImageWeb)
                          if (_selectedXFile != null && _imageBytes != null) {
                            // ดึงนามสกุลไฟล์
                            String extension =
                                _selectedXFile!.name.split('.').last;
                            String fileName =
                                'task_${DateTime.now().millisecondsSinceEpoch}.$extension';

                            // เรียกฟังก์ชัน uploadImageWeb ที่เราเพิ่งทำไปใน Service
                            String? uploadedUrl = await _supabaseService
                                .uploadImageWeb(_imageBytes!, fileName);

                            if (uploadedUrl != null) {
                              imageUrl = uploadedUrl;
                            }
                          }

                          Task newTask = Task(
                            task_name: _nameController.text,
                            task_where: _whereController.text,
                            task_person: int.tryParse(_personController.text),
                            task_duedate: _dateController.text,
                            task_status: false,
                            task_image_url: imageUrl,
                          );

                          await _supabaseService.insertTask(newTask);

                          setState(() {
                            _isUploading = false;
                          });

                          if (context.mounted) Navigator.pop(context);
                        },
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SAVE TASK',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
