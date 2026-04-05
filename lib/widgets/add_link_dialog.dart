import 'package:flutter/material.dart';
import 'package:stashlink/models/list_model.dart';

class AddLinkDialog extends StatefulWidget {
  const AddLinkDialog({super.key, this.initialUrl});
  final String? initialUrl;

  @override
  State<AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<AddLinkDialog> {
  final TextEditingController titleControl = TextEditingController();
  final TextEditingController urlControl = TextEditingController();
  final FocusNode titleFocus = FocusNode();

  static const double phi = 1.618;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      urlControl.text = widget.initialUrl!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    titleControl.dispose();
    urlControl.dispose();
    titleFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final title = titleControl.text.trim();
    final url = urlControl.text.trim();

    if (title.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Both fields are required',
          ),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      ListModel(
        title: title,
        url: url,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = 320.0;
    final spacing = 12.0;
    final largeSpacing = spacing * phi;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16 * phi,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Bookmark',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: largeSpacing,
              ),
              TextField(
                controller: titleControl,
                focusNode: titleFocus,
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: spacing),
              TextField(
                controller: urlControl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'URL',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(
                height: largeSpacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  SizedBox(
                    width: spacing,
                  ),
                  TextButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
