import 'package:flutter/material.dart';
import 'package:flutter_task_v1_app/models/task.dart';
import 'package:flutter_task_v1_app/services/supabase_service.dart';

class UpdateDeletTaskUi extends StatefulWidget {
  final Task currentTask;

  const UpdateDeletTaskUi({super.key, required this.currentTask});

  @override
  State<UpdateDeletTaskUi> createState() => _UpdateDeletTaskUiState();
}

class _UpdateDeletTaskUiState extends State<UpdateDeletTaskUi> {
  final SupabaseService _supabaseService = SupabaseService();

  late TextEditingController _nameController;
  late TextEditingController _whereController;
  late TextEditingController _personController;
  late TextEditingController _dateController;
  bool _taskStatus = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentTask.task_name);
    _whereController =
        TextEditingController(text: widget.currentTask.task_where);
    _personController = TextEditingController(
        text: widget.currentTask.task_person?.toString() ?? '');
    _dateController =
        TextEditingController(text: widget.currentTask.task_duedate);
    _taskStatus = widget.currentTask.task_status ?? false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Task Na Ja V1 (Edit)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.green, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.0),
                    //เช็คว่ามี URL รูปภาพไหม
                    child: (widget.currentTask.task_image_url != null &&
                            widget.currentTask.task_image_url!.isNotEmpty)
                        //มี URL ให้ดึงรูปจากอินเทอร์เน็ต
                        ? Image.network(
                            widget.currentTask.task_image_url!,
                            fit: BoxFit.cover,
                            //ใส่ระบบป้องกัน Error: ถ้าดึงรูปจากเน็ตไม่ได้
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderAsset(),
                          )
                        //ไม่มี URL ให้โชว์รูปสำรอง
                        : _buildPlaceholderAsset(),
                  ),
                ),
              ),
              // ------------------------------------------
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่องาน',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title, color: Colors.green),
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              TextField(
                controller: _personController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'จำนวนคน',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.people, color: Colors.green),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'วันที่ครบกำหนด',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.green),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _taskStatus
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: _taskStatus ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        const Text('สถานะงาน:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Switch(
                      value: _taskStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.orange,
                      inactiveTrackColor: Colors.orange.shade200,
                      onChanged: (value) {
                        setState(() {
                          _taskStatus = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          Task updatedTask = Task(
                            id: widget.currentTask.id,
                            task_name: _nameController.text,
                            task_where: _whereController.text,
                            task_person: int.tryParse(_personController.text),
                            task_duedate: _dateController.text,
                            task_status: _taskStatus,
                            task_image_url: widget.currentTask.task_image_url,
                          );

                          await _supabaseService.updateTask(updatedTask);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('แก้ไข (UPDATE)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          //เช็คก่อนว่างานนี้มีรูปลิงก์ไว้ไหม
                          if (widget.currentTask.task_image_url != null &&
                              widget.currentTask.task_image_url!.isNotEmpty) {
                            //ถ้ามีรูป ให้ไปสั่งลบไฟล์ออกจาก Storage Bucket ก่อน
                            await _supabaseService.deleteImage(
                                widget.currentTask.task_image_url!);
                          }
                          //ลบข้อมูลงานออกจากตาราง Database
                          await _supabaseService
                              .deleteTask(widget.currentTask.id!);
                          //กลับหน้าแรก
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('ลบทิ้ง (DELETE)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ฟังก์ชันสร้างรูปสำรอง (Helper Method) ---
  Widget _buildPlaceholderAsset() {
    return Image.asset(
      'assets/icon/scrumban.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image, size: 80, color: Colors.grey),
    );
  }
}
