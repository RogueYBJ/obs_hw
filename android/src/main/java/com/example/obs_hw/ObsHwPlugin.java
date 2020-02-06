package com.example.obs_hw;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import com.obs.services.ObsClient;
import com.obs.services.exception.ObsException;
import com.obs.services.model.PutObjectResult;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ObsHwPlugin */
public class ObsHwPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "obs_hw");
    channel.setMethodCallHandler(new ObsHwPlugin());
  }

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
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "obs_hw");
    channel.setMethodCallHandler(new ObsHwPlugin());
  }



  @Override
  public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("upImage")) {
      new Thread(new Runnable(){
        @Override
        public void run() {
          upImage(call,result);
        }
      }).start();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  private Handler handler = new Handler() {
    @Override
    public void handleMessage(Message msg) {
      Map map = (Map) msg.obj;
      Result result = (Result) map.get("k");
      String url = (String) map.get("v");
      result.success(url);
    }
  };



  public void upImage(MethodCall call, Result result){
    String ak = call.argument("ak");
    String sk = call.argument("sk");
    String endPoint = call.argument("endPoint");
    String bucketName = call.argument("bucketName");
    String bucketDomain = call.argument("bucketDomain");
    String data = call.argument("data");
    String key = call.argument("key");
    Message message = new Message();
    HashMap m = new HashMap();
    Object o = result;
    m.put("k",result);
    ObsClient obsClient = null;
    try
    {
      // 创建ObsClient实例
      obsClient = new ObsClient(ak, sk, endPoint);
      InputStream inputStream = Bitmap2InputStream(getimg(data));
      PutObjectResult response = obsClient.putObject(bucketName, key, inputStream);
      obsClient.close();
      m.put("v",response.getObjectUrl());
    }
    catch (ObsException e)
    {
      Log.e("PutObject", "Response Code: " + e.getResponseCode());
      Log.e("PutObject", "Error Message: " + e.getErrorMessage());
      Log.e("PutObject", "Error Code:       " + e.getErrorCode());
      Log.e("PutObject", "Request ID:      " + e.getErrorRequestId());
      Log.e("PutObject", "Host ID:           " + e.getErrorHostId());
    } catch (IOException e) {
      e.printStackTrace();
    } finally{
      // 关闭ObsClient实例，如果是全局ObsClient实例，可以不在每个方法调用完成后关闭
      // ObsClient在调用ObsClient.close方法关闭后不能再次使用
      if(obsClient != null){
        try
        {
          obsClient.close();
        }
        catch (IOException e)
        {
        }
      }
    }
    message.obj = m;
    handler.sendMessage(message);
  }

  public Bitmap getimg(String str){
    byte[] bytes;
    bytes= Base64.decode(str,   0);
    return BitmapFactory.decodeByteArray(bytes,   0, bytes.length);
  }
  // 将Bitmap转换成InputStream
  public InputStream Bitmap2InputStream(Bitmap bm) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    bm.compress(Bitmap.CompressFormat.JPEG, 100, baos);
    InputStream is = new ByteArrayInputStream(baos.toByteArray());
    return is;
  }
}
