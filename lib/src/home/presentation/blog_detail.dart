import 'package:autoformsai_blogs/core/app_logger.dart';
import 'package:autoformsai_blogs/core/app_router.dart';
import 'package:autoformsai_blogs/core/app_widgets/app_image_widget.dart';
import 'package:autoformsai_blogs/core/constraints.dart';
import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/layout_components/web_app_responsive_widget.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/core/text_cleaner.dart';
import 'package:autoformsai_blogs/data/data_repository.dart';
import 'package:autoformsai_blogs/data/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlogDetail extends StatelessWidget {
  const BlogDetail({super.key, this.blogPostModel, this.title, this.id});

  final BlogPostModel? blogPostModel;
  final String? title;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogDetailProvider(
        blogPostModelData: blogPostModel,
        title: title,
        id: id,
      )..init(),
      child: BlogDetailWidget(),
    );
  }
}

class BlogDetailWidget extends StatefulWidget {
  const BlogDetailWidget({super.key});

  @override
  State<BlogDetailWidget> createState() => _BlogDetailWidgetState();
}

class _BlogDetailWidgetState extends State<BlogDetailWidget> {
  final FlutterTts _flutterTts = FlutterTts();
  final ValueNotifier<bool> _isSpeaking = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((v){
    //   context.read<BlogDetailProvider>().init();
    // });
    _initializeTTS();
  }

  // Initialize TTS and configure settings
  void _initializeTTS() {
    _flutterTts.setCompletionHandler(() {
      _isSpeaking.value = false; // Stop TTS when reading is complete
    });

    _flutterTts.setErrorHandler((msg) {
      AppLogger.e("TTS Error: $msg");
      _isSpeaking.value = false;
    });
  }

  Future<void> _speakHtmlContent(BlogPostModel blogPostModel) async {
    try {
      String textToRead = HtmlParser.parseHTML(blogPostModel.description).text;
      String ttsContent = '${blogPostModel.title} \n $textToRead';
      ttsContent = TextCleaner.cleanStringForTTS(ttsContent);

      var availableVoices = await _flutterTts.getVoices;
      AppLogger.i("available voices - $availableVoices");
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setVoice(
        {
          'name': 'Rishi',
          'locale': 'en-IN',
        },
      );
      await _flutterTts.setPitch(1.0);
      _isSpeaking.value = true;
      await _flutterTts.speak(ttsContent);
    } catch (e) {
      AppLogger.e(e);
    }
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking.value = false;
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WepAppResponsiveWidget(
        child: Consumer<BlogDetailProvider>(builder: (context, state, child) {
          if (state.blogPostModel == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blog Title and Author Section
                Text(
                  state.blogPostModel!.title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        try {
                          launchUrlString(profileLink);
                        } catch (e) {
                          AppLogger.e(e);
                        }
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(profileImageLink),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Subhash Chandra Shukla',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (state.blogPostModel!.postTimeAgo != null)
                          Text(
                            state.blogPostModel!.postTimeAgo!,
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      state.blogPostModel!.calculateReadTime,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 5),

                // TTS and Share Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isSpeaking,
                      builder: (context, speaking, child) {
                        return InkWell(
                          onTap: () {
                            if (speaking) {
                              _stopSpeaking();
                            } else {
                              _speakHtmlContent(
                                state.blogPostModel!,
                              );
                            }
                          },
                          child: Icon(
                            speaking ? Icons.stop : Icons.volume_up,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    // const SizedBox(width: 10),
                    // InkWell(
                    //     onTap: () {
                    //       try {
                    //         final link =
                    //             "https://www.articles.autoformsai.com${getBlogDetailRoute(state.blogPostModel!)}";
                    //         onShare(
                    //           link,
                    //           subject: '${state.blogPostModel?.title}',
                    //           text: 'Check out this article',
                    //         );
                    //       } catch (e) {
                    //         AppLogger.e(e);
                    //       }
                    //     },
                    //     child: Icon(Icons.ios_share_outlined, size: 30)),
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () async {
                          try {
                            final link =
                                "https://www.articles.autoformsai.com${getBlogDetailRoute(state.blogPostModel!)}";
                            try {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: link,
                                ),
                              );
                              getIt<EasyLoadingService>().showToast(
                                content: "Link successfully copied to clipboard!",
                              );
                            } catch (e) {
                              AppLogger.e(e);
                            }
                          } catch (e) {
                            AppLogger.e(e);
                          }
                        },
                        child: Icon(Icons.copy, size: 30)),
                    const SizedBox(width: 10),
                  ],
                ),

                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 20),
                AppImageWidget(
                  imageUrl: state.blogPostModel!.image,
                  height: null,
                  useDefaultImageSize: true,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 20,
                ),
                SelectionArea(
                  child: HtmlWidget(
                    state.blogPostModel!.description,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // void onShare(String link, {String? subject, String? text}) async {
  //   final data = {
  //     'title': subject,
  //     'text': text,
  //     'url': link,
  //   };
  //   try {
  //     html.window.navigator.share(data);
  //   } catch (e) {
  //     AppLogger.e(e);
  //   }
  // }
}

class BlogDetailProvider extends ChangeNotifier {
  final BlogPostModel? blogPostModelData;
  final String? title;
  final String? id;

  BlogDetailProvider({required this.blogPostModelData, required this.title, required this.id});

  BlogPostModel? _blogPostModel;

  BlogPostModel? get blogPostModel => _blogPostModel;
  String? error;

  Future<void> init() async {
    if (blogPostModelData != null) {
      _blogPostModel = blogPostModelData!;
      notifyListeners();
      return;
    } else {
      if (id == null) {
        error = 'Invalid article Id';
        notifyListeners();
        return;
      }
      var res = await DataRepository.instance.fetchPostById(id!);
      if (res != null) {
        _blogPostModel = res;
      } else {
        error = 'Article not found!';
      }
      notifyListeners();
    }
  }
}
