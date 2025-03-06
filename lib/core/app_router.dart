import 'package:autoformsai_blogs/core/layout_components/web_app_responsive_widget.dart';
import 'package:autoformsai_blogs/data/model/blog_model.dart';
import 'package:autoformsai_blogs/src/admin/presentation/admin_login.dart';
import 'package:autoformsai_blogs/src/admin/presentation/home.dart';
import 'package:autoformsai_blogs/src/home/presentation/blog_detail.dart';
import 'package:autoformsai_blogs/src/home/presentation/bloging_home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteName.blogHome,
  routes: [
    GoRoute(
      path: RouteName.blogHome,
      builder: (context, state) => BlogHomePage(),
      routes: [
        GoRoute(
          path: '/blog-post/:blogTitle/:postId',
          builder: (context, state) {
            final post = state.extra as BlogPostModel?;
            String? postId = state.pathParameters['postId'];
            String? title = state.pathParameters['blogTitle'];
            if (post == null && postId==null) {
              return Scaffold(
                body: Center(
                  child: Text(
                    "Post Not Found",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            return BlogDetail(
              blogPostModel: post,
              id: postId,
              title: title,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteName.adminLogin,
      builder: (context, state) {
        return WepAppResponsiveWidget(
          child: Center(
            child: Material(
              elevation: 20,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  minHeight: MediaQuery.of(context).size.height * 0.50,
                ),
                child: AdminLogin(),
              ),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: RouteName.adminHome,
      builder: (context, state) {
        return AdminHome();
      },
    ),
    GoRoute(
      path: RouteName.errorPage,
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text(
              "Something Went Wrong!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text(
          "404 - Page Not Found",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ),
  ),
);

class RouteName {
  static String blogHome = '/';
  static String adminHome = '/admin-home';
  static String adminLogin = '/admin-login';
  static String errorPage = '/error-page';
}

String getBlogDetailRoute(BlogPostModel? post, {String? title, String? id}) {
  String titleParam = title ?? post?.title ?? '';
  String idParam = id ?? post?.id ?? '';
  return '/blog-post/${titleParam.replaceAll(' ', '-')}/$idParam';
}
