//ไฟล์นี้ใช้สำหรับสร้างการทำงานต่างๆ กับ Supabase
// CRUD กับ Table -> Database (PostgreSQL) -> Supabase
// upload/delete file กับ Bucket -> Storage -> Supabase
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_task_v1_app/models/task.dart';
import 'dart:io';
import 'dart:typed_data'; // --- เพิ่มตัวนี้เพื่อรองรับข้อมูลรูปแบบ Bytes บน Web ---

class SupabaseService {
  //สร้าง instance/object/ตัวแทน ของ Supabase -----------
  final supabase = Supabase.instance.client;

  // ชื่อ Bucket (เช็คให้ตรงกับใน Supabase Console นะคะ)
  final String bucketName = 'task_bk';

  // --- 1. เมธอดดึงข้อมูลงานทั้งหมด (Read) ---
  Future<List<Task>> getTasks() async {
    final data =
        await supabase.from('task_tb').select('*').order('id', ascending: true);
    return data.map((task) => Task.fromJson(task)).toList();
  }

  // --- 2. เมธอดเพิ่มข้อมูล (Create) ---
  Future<void> insertTask(Task task) async {
    final taskData = task.toJson();
    taskData.remove('id'); // ให้ Supabase รัน ID อัตโนมัติ
    await supabase.from('task_tb').insert(taskData);
  }

  // --- 3. เมธอดแก้ไขข้อมูล (Update) ---
  Future<void> updateTask(Task task) async {
    final taskData = task.toJson();
    taskData.remove('id'); // ไม่ต้องส่ง ID ไปในก้อนข้อมูลที่จะแก้
    await supabase.from('task_tb').update(taskData).eq('id', task.id!);
  }

  // --- 4. เมธอดลบข้อมูล (Delete) ---
  Future<void> deleteTask(String id) async {
    await supabase.from('task_tb').delete().eq('id', id);
  }

  // --- 5. เมธอดอัปโหลดไฟล์ (Mobile - ใช้ File) ---
  Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      await supabase.storage.from(bucketName).upload(fileName, imageFile);
      final imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปโหลดรูป (Mobile): $e');
      return null;
    }
  }

  // --- 6. เมธอดอัปโหลดไฟล์ (Web - ใช้ Uint8List) ---
  // บรรทัดนี้จะช่วยแก้ปัญหา "Image.file is not supported on Flutter Web" ค่ะ
  Future<String?> uploadImageWeb(Uint8List imageBytes, String fileName) async {
    try {
      // บนเว็บต้องใช้ uploadBinary ถึงจะทำงานได้ค่ะ
      await supabase.storage
          .from(bucketName)
          .uploadBinary(fileName, imageBytes);
      final imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปโหลดรูป (Web): $e');
      return null;
    }
  }

  // --- 7. เมธอดลบไฟล์จาก Storage ---
  Future<void> deleteImage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last;
      await supabase.storage.from(bucketName).remove([fileName]);
    } catch (e) {
      print('เกิดข้อผิดพลาดในการลบรูป: $e');
    }
  }
}
