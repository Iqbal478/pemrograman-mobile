import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // <--- TAMBAHKAN BARIS INI
      title: 'Form Validasi Mahasiswa',
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
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk Input Text
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variables untuk Form Lainnya
  String? _jurusan; // Dropdown
  double _semester = 1.0; // Slider
  bool _isAgreed = false; // Switch

  // Data Hobi (Checkbox)
  final Map<String, bool> _hobbies = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Traveling': false,
  };

  // List Jurusan untuk Dropdown
  final List<String> _jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Desain Komunikasi Visual',
    'Manajemen Bisnis',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fungsi Submit
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasi Manual untuk Hobi (karena Checkbox tidak punya validator bawaan di FormField biasa)
      if (!_hobbies.values.contains(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih setidaknya satu hobi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Tampilkan Hasil
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Berhasil Disimpan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Nama: ${_namaController.text}'),
                Text('Email: ${_emailController.text}'),
                Text('No HP: ${_phoneController.text}'),
                Text('Jurusan: $_jurusan'),
                Text('Semester: ${_semester.toInt()}'),
                Text('Hobi: ${_hobbies.keys.where((k) => _hobbies[k]!).join(', ')}'),
                Text('Status: ${_isAgreed ? "Setuju" : "Tidak Setuju"}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
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
            // Logika Validasi per Step
            bool isStepValid = true;

            if (_currentStep == 0) {
              // Validasi Step 1: Text Fields
              if (_namaController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  !_emailController.text.contains('@') ||
                  _phoneController.text.isEmpty) {
                isStepValid = false;
                _formKey.currentState!.validate(); // Trigger pesan error merah muncul
              }
            } else if (_currentStep == 1) {
              // Validasi Step 2: Dropdown & Hobi
              if (_jurusan == null) {
                isStepValid = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harap pilih jurusan!')),
                );
              } else if (!_hobbies.values.contains(true)) {
                isStepValid = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih minimal satu hobi!')),
                );
              }
            } else if (_currentStep == 2) {
              // Validasi Step 3: Switch Agreement
              if (!_isAgreed) {
                isStepValid = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Anda harus menyetujui syarat & ketentuan!')),
                );
              }
            }

            if (isStepValid) {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _submitForm();
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          steps: [
            // STEP 1: Data Pribadi
            Step(
              title: const Text('Data Pribadi'),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nama wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email wajib diisi';
                      if (!value.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nomor HP wajib diisi';
                      if (value.length < 10) return 'Nomor HP minimal 10 digit';
                      // Cek apakah angka semua
                      if (double.tryParse(value) == null) return 'Hanya boleh angka';
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // STEP 2: Data Akademik & Minat
            Step(
              title: const Text('Akademik & Minat'),
              isActive: _currentStep >= 1,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Jurusan
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      border: OutlineInputBorder(),
                    ),
                    value: _jurusan,
                    items: _jurusanList
                        .map((jurusan) => DropdownMenuItem(
                              value: jurusan,
                              child: Text(jurusan),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _jurusan = value),
                    validator: (value) =>
                        value == null ? 'Jurusan wajib dipilih' : null,
                  ),
                  const SizedBox(height: 20),

                  // Slider Semester
                  Text('Semester: ${_semester.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: _semester.toInt().toString(),
                    onChanged: (value) => setState(() => _semester = value),
                  ),
                  const SizedBox(height: 10),

                  // Checkbox Hobi
                  const Text('Hobi (Pilih Minimal 1):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                ],
              ),
            ),

            // STEP 3: Konfirmasi
            Step(
              title: const Text('Persetujuan'),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  const Text(
                    'Pastikan semua data yang Anda masukkan sudah benar. Dengan menekan tombol setuju, Anda bertanggung jawab atas keaslian data.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Saya menyetujui syarat & ketentuan'),
                    value: _isAgreed,
                    onChanged: (bool value) {
                      setState(() {
                        _isAgreed = value;
                      });
                    },
                  ),
                  if (!_isAgreed)
                    const Text(
                      ' * Wajib disetujui',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}