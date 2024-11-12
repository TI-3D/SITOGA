import 'package:flutter/material.dart';

class HapusTanamanDialog extends StatelessWidget {
  final String tanamanName;
  final VoidCallback onDelete;

  const HapusTanamanDialog({
    Key? key,
    required this.tanamanName,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Apakah anda ingin menghapus $tanamanName",
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Batal", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text("Hapus"),
        ),
      ],
    );
  }
}
