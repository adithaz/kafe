import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kafe/widgets/custom_confirmation_dialog.dart';
import 'package:kafe/widgets/custom_information_dialog.dart';
import 'package:kafe/widgets/custom_loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class UIService {
  void showSimpleSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showSimpleInformationDialog(BuildContext context, String? title, String description, String? buttonText, VoidCallback? onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomInformationDialog(
          title: title ?? "Informasi",
          description: description,
          buttonText: buttonText ?? "Baik",
          onTap: () {
            onTap != null ? onTap() : Navigator.pop(context);
          },
        );
      },
    );
  }

  void showSimpleConfirmationDialog(BuildContext context, String title, String description, String confirmText, String? cancelText, VoidCallback onConfirm, VoidCallback? onCancel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: title,
          description: description,
          confirmText: confirmText,
          cancelText: cancelText ?? "Batal",
          onConfirm: onConfirm,
          onCancel: () {
            onCancel != null ? onCancel() : Navigator.pop(context);
          },
        );
      },
    );
  }

  void showSimpleLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CustomLoadingDialog();
      },
    );
  }

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith("http") ? url : "https://$url");
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await launchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} tahun";
    } else if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} bulan";
    } else if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} minggu";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} hari";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} jam";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} menit";
    }
    return "Baru saja";
  }
}