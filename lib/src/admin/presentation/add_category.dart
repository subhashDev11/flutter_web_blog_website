import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/data/data_repository.dart';
import 'package:autoformsai_blogs/data/model/category_model.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final ValueNotifier<List<String>> _tagsNotifier = ValueNotifier(<String>[]);
  final TextEditingController _categoryCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Add new category"),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _categoryCtrl,
            decoration: InputDecoration(
              hintText: "Enter category name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Tags"),
          SizedBox(
            height: 10,
          ),
          ValueListenableBuilder(
            valueListenable: _tagsNotifier,
            builder: (_, tags, child) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: tags.map((e) {
                  return Chip(
                    color: WidgetStatePropertyAll(
                      Colors.black,
                    ),
                    label: Text(
                      e,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onDeleted: () {
                      _tagsNotifier.value.remove(e);
                    },
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                ),
                onPressed: () {
                  showAdaptiveDialog(
                      context: context,
                      builder: (_) {
                        String? tag;
                        return AlertDialog.adaptive(
                          title: Text("Add tag"),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter tag",
                            ),
                            onChanged: (v) {
                              tag = v;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (tag == null) return;
                                _tagsNotifier.value = [
                                  ..._tagsNotifier.value,
                                  ...[tag!]
                                ];
                                Navigator.pop(context);
                              },
                              child: Text("Add"),
                            )
                          ],
                        );
                      },
                  );
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                label: Text("Add more tags"),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              onPressed: () async {
                if (_categoryCtrl.text.isEmpty || _tagsNotifier.value.isEmpty) {
                  getIt<EasyLoadingService>().showToast(
                    content: "Please enter the category name and tags",
                  );
                  return;
                }
                bool success = await addNewCategory(_categoryCtrl.text);
                if (success) {
                  context.read<BlogCubit>().init();
                  getIt<EasyLoadingService>().showToast(content: 'Category added successfully',);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<bool> addNewCategory(String categoryName) async {
    getIt<EasyLoadingService>().show();
    bool added = await DataRepository.instance.addCategory(
      CategoryModel(
        categoryName: categoryName,
        categoryId: '$categoryName-id-${DateTime.now().millisecondsSinceEpoch}',
        tags: _tagsNotifier.value,
      ),
    );
    getIt<EasyLoadingService>().hide();
    return added;
  }
}
