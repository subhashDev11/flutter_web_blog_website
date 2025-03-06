import 'package:another_easyloading/another_easyloading.dart';
import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/layout_components/column_spacer.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/src/admin/presentation/add_category.dart';
import 'package:autoformsai_blogs/src/admin/state/admin_home_provider.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHomeProvider(),
      child: AdminHomeWidget(),
    );
  }
}

class AdminHomeWidget extends StatefulWidget {
  const AdminHomeWidget({super.key});

  @override
  _AdminHomeWidgetState createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final TextEditingController _titleCtrl = TextEditingController();
  late AdminHomeProvider _adminHomeProvider;
  late BlogCubit _blogCubit;
  bool authenticated = true;

  @override
  void initState() {
    _adminHomeProvider = context.read<AdminHomeProvider>();
    _blogCubit = context.read<BlogCubit>();
    WidgetsBinding.instance.addPostFrameCallback((v){
      init();
    },);
    super.initState();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authenticated = prefs.getBool("authenticated") ?? false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(authenticated){
      return Scaffold(
        appBar: AppBar(
          title: Text('Add new post'),
          actions: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return AddCategory();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                );
              },
              child: Text("Add new category"),
            ),
            TextButton(
              onPressed: () {
                final markdown = quillDeltaToHtml(_controller.document.toDelta().toJson());
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Preview"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              _titleCtrl.text,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (_adminHomeProvider.selectedImage != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20.0,
                                ),
                                child: Image.memory(
                                  _adminHomeProvider.selectedImage!,
                                ),
                              ),
                            HtmlWidget(markdown),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text("Preview"),
            ),
            TextButton(
              onPressed: () {
                if (_titleCtrl.text.isEmpty) {
                  getIt<EasyLoadingService>().showToast(
                    content: "Please enter title",
                    toastType: ToastType.error,
                  );
                  return;
                } else if (_adminHomeProvider.selectedCategory == null) {
                  getIt<EasyLoadingService>().showToast(
                    content: "Please select category",
                    toastType: ToastType.error,
                  );
                  return;
                } else if (_adminHomeProvider.selectedImage == null) {
                  getIt<EasyLoadingService>().showToast(
                    content: "Please pick the thumbnail image",
                    toastType: ToastType.error,
                  );
                  return;
                } else {
                  final htmlStr = quillDeltaToHtml(_controller.document.toDelta().toJson());
                  _adminHomeProvider.onPostSubmit(
                    context,
                    title: _titleCtrl.text,
                    description: htmlStr,
                    category: _adminHomeProvider.selectedCategory!,
                  );
                }
              },
              child: Text("Publish"),
            ),
          ],
        ),
        body: _buildCreatePostForm(),
      );
    }else{
      return Scaffold(
        body: Center(
          child: Text("Invalid credentials"),
        ),
      );
    }
  }

  Widget _buildCreatePostForm() {
    return Consumer<AdminHomeProvider>(builder: (context, state, child) {
      return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ColumnSpacer(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacerWidget: SizedBox(
              height: 15,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<BlogCubit, BlogState>(
                          builder: (context, state) {
                            return DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                items: state.categories
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.categoryName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v == null) return;
                                  _adminHomeProvider.onCategorySelected(v);
                                },
                                value: state.selectedCategory,
                                hint: Text("Select"),
                                decoration: InputDecoration.collapsed(
                                  hintText: "Select",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Title",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _titleCtrl,
                          decoration: InputDecoration.collapsed(
                            hintText: "Enter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _adminHomeProvider.galleryImagePicker();
                },
                child: Container(
                  height: 300,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    image: state.selectedImage != null
                        ? DecorationImage(
                            image: MemoryImage(state.selectedImage!),
                          )
                        : DecorationImage(
                            image: AssetImage('assets/image_icon.png'),
                          ),
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              quill.QuillToolbar.simple(
                controller: _controller,
                configurations: quill.QuillSimpleToolbarConfigurations(
                  showFontFamily: true,
                  showFontSize: true,
                  showDividers: true,
                  showBoldButton: true,
                  showItalicButton: true,
                  showCenterAlignment: true,
                  showAlignmentButtons: true,
                  showCodeBlock: true,
                  showUndo: true,
                  showUnderLineButton: true,
                  showClearFormat: true,
                  showClipboardCopy: true,
                  showClipboardPaste: true,
                  showClipboardCut: true,
                  showBackgroundColorButton: true,
                  showQuote: true,
                  showHeaderStyle: true,
                  showListBullets: true,
                  showSubscript: true,
                  showSuperscript: true,
                  showJustifyAlignment: true,
                  showIndent: true,
                  sectionDividerSpace: 10,
                  showSearchButton: false,
                  sectionDividerColor: Colors.grey.shade200,
                  showLineHeightButton: true,
                  showListNumbers: true,
                  showColorButton: true,
                  showLink: true,
                  showStrikeThrough: true,
                  showInlineCode: true,
                  showDirection: true,
                  showSmallButton: true,
                  showRightAlignment: true,
                  showLeftAlignment: true,
                  showRedo: true,
                  showListCheck: true,
                ),
              ),
              Expanded(
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  configurations: quill.QuillEditorConfigurations(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String quillDeltaToHtml(List<Map<String, dynamic>> delta) {
    final converter = QuillDeltaToHtmlConverter(
      delta,
      ConverterOptions(
        multiLineCustomBlock: true,
        multiLineParagraph: true,
        multiLineCodeblock: true,
        multiLineHeader: true,
        multiLineBlockquote: true,
      ),
    );
    return converter.convert();
  }
}
