import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 全局错误处理器
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();

  BuildContext? _context;

  /// 设置全局上下文用于显示错误对话框
  void setContext(BuildContext context) {
    _context = context;
  }

  /// 初始化全局错误处理
  static void initialize() {
    // 捕获Flutter框架错误
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _instance._handleError(
        details.exception,
        details.stack,
        details.context?.toString() ?? 'Flutter错误',
      );
    };

    // 捕获平台错误
    PlatformDispatcher.instance.onError = (error, stack) {
      _instance._handleError(error, stack, '平台错误');
      return true;
    };
  }

  /// 在Zone中运行应用以捕获所有异步错误
  /// [onInit] 初始化函数，执行初始化逻辑并返回要运行的应用Widget
  static void runAppWithErrorHandler(Future<Widget> Function() onInit) {
    runZonedGuarded(
      () async {
        // 在Zone内部初始化Flutter binding
        WidgetsFlutterBinding.ensureInitialized();

        // 初始化错误处理器
        initialize();

        // 执行自定义初始化函数并获取Widget
        final app = await onInit();

        // 运行应用
        runApp(app);
      },
      (error, stack) {
        _instance._handleError(error, stack, '未捕获的异步错误');
      },
    );
  }

  /// 处理错误
  void _handleError(Object error, StackTrace? stack, String context) {
    // 在debug模式下打印到控制台
    if (kDebugMode) {
      print('========== 错误发生 ==========');
      print('上下文: $context');
      print('错误: $error');
      print('堆栈追踪:\n$stack');
      print('==============================');
    }

    // 显示错误对话框 - 检查MaterialLocalizations是否可用
    if (_context != null && _context!.mounted) {
      try {
        // 尝试获取MaterialLocalizations，如果不存在则不显示对话框
        Localizations.of<MaterialLocalizations>(
          _context!,
          MaterialLocalizations,
        );
        _showErrorDialog(_context!, error, stack, context);
      } catch (e) {
        // MaterialApp 尚未完全初始化，只打印错误
        if (kDebugMode) {
          print('⚠️ 无法显示错误对话框：MaterialApp 尚未初始化');
        }
      }
    }
  }

  /// 显示错误对话框
  void _showErrorDialog(
    BuildContext context,
    Object error,
    StackTrace? stack,
    String errorContext,
  ) {
    // 使用Future.microtask确保在下一帧显示对话框
    Future.microtask(() {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ErrorDialog(
            error: error,
            stackTrace: stack,
            context: errorContext,
          ),
        );
      }
    });
  }
}

/// 错误显示对话框
class ErrorDialog extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final String context;

  const ErrorDialog({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = _formatErrorText();

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '发生错误',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '错误上下文：',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(this.context, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  Text(
                    '错误信息：',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    error.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            if (stackTrace != null) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text(
                  '堆栈追踪',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        stackTrace.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => _copyToClipboard(context, errorText),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('复制错误信息'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue[700]),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
      ],
    );
  }

  /// 格式化错误文本
  String _formatErrorText() {
    final buffer = StringBuffer();
    buffer.writeln('========== 错误报告 ==========');
    buffer.writeln('时间: ${DateTime.now()}');
    buffer.writeln('上下文: $context');
    buffer.writeln();
    buffer.writeln('错误信息:');
    buffer.writeln(error.toString());
    buffer.writeln();
    if (stackTrace != null) {
      buffer.writeln('堆栈追踪:');
      buffer.writeln(stackTrace.toString());
    }
    buffer.writeln('==============================');
    return buffer.toString();
  }

  /// 复制错误信息到剪贴板
  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('错误信息已复制到剪贴板'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
