package io.github.v7lin.weibo_kit;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WeiboKitPlugin */
public class WeiboKitPlugin implements FlutterPlugin, ActivityAware {
  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    WeiboKit weiboKit = new WeiboKit(registrar.context(), registrar.activity());
    registrar.addActivityResultListener(weiboKit);
    weiboKit.startListening(registrar.messenger());
  }

  // --- FlutterPlugin

  private final WeiboKit weiboKit;

  private ActivityPluginBinding pluginBinding;

  public WeiboKitPlugin() {
    weiboKit = new WeiboKit();
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    weiboKit.setApplicationContext(binding.getApplicationContext());
    weiboKit.setActivity(null);
    weiboKit.startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    weiboKit.stopListening();
    weiboKit.setActivity(null);
    weiboKit.setApplicationContext(null);
  }

  // --- ActivityAware

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    weiboKit.setActivity(binding.getActivity());
    pluginBinding = binding;
    pluginBinding.addActivityResultListener(weiboKit);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    weiboKit.setActivity(null);
    pluginBinding.removeActivityResultListener(weiboKit);
    pluginBinding = null;
  }
}
