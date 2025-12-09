import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // <-- Tambahkan baris ini
      title: 'Form Mahasiswa Validasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FormMahasiswaPage(),
    );
  }
}
class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  // Key untuk Form Validation
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk Text Input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // State Variables
  int _currentStep = 0;
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _agree = false;

  // Data Hobi (Map untuk menyimpan status checkbox)
  final Map<String, bool> _hobbies = {
    'Membaca': false,
    'Olahraga': false,
    'Coding': false,
    'Musik': false,
  };

  // List Pilihan Jurusan
  final List<String> _jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Ilmu Komputer',
    'Teknologi Informasi'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fungsi untuk submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasi manual untuk Hobi (minimal 1 dipilih)
      if (!_hobbies.containsValue(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih setidaknya satu hobi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validasi manual untuk Switch Persetujuan
      if (!_agree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui persyaratan!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Jika semua valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data Mahasiswa Berhasil Disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Mahasiswa Validasi'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            // Logika tombol Lanjut / Simpan
            if (_currentStep < 2) {
              setState(() => _currentStep += 1);
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            // Logika tombol Kembali
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Simpan' : 'Lanjut'),
                  ),
                  const SizedBox(width: 10),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Kembali'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // STEP 1: Identitas Diri (Nama, Email, No HP)
            Step(
              title: const Text('Identitas Diri'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.editing,
              content: Column(
                children: [
                  // Field Nama
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  
                  // Field Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Field Nomor HP
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor HP wajib diisi';
                      }
                      // Cek apakah hanya angka
                      if (double.tryParse(value) == null) {
                        return 'Hanya boleh angka';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // STEP 2: Data Akademik (Jurusan, Semester)
            Step(
              title: const Text('Data Akademik'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.editing,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Jurusan
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedJurusan,
                    items: _jurusanList.map((String jurusan) {
                      return DropdownMenuItem(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedJurusan = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Jurusan wajib dipilih' : null,
                  ),
                  const SizedBox(height: 20),

                  // Slider Semester
                  const Text('Semester Saat Ini:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: _semester.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _semester = value;
                      });
                    },
                  ),
                  Center(child: Text('Semester ${_semester.round()}')),
                ],
              ),
            ),

            // STEP 3: Minat & Persetujuan (Hobi, Switch)
            Step(
              title: const Text('Minat & Persetujuan'),
              isActive: _currentStep >= 2,
              state: _currentStep == 2 ? StepState.editing : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Hobi (Minimal 1):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  // Checkbox Hobi
                  ..._hobbies.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: _hobbies[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _hobbies[key] = value!;
                        });
                      },
                    );
                  }).toList(),
                  const Divider(),
                  
                  // Switch Persetujuan
                  SwitchListTile(
                    title: const Text('Saya menyetujui syarat & ketentuan'),
                    value: _agree,
                    onChanged: (bool value) {
                      setState(() {
                        _agree = value;
                      });
                    },
                  ),
                  if (!_agree)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Wajib disetujui',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}