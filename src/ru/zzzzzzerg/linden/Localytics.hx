package ru.zzzzzzerg.linden;

#if android

import openfl.utils.JNI;
import haxe.CallStack;

class LocalyticsImpl
{
  private var _localytics : Dynamic = null;

  public function new()
  {
    initJNI();
  }

  public function start(localyticsKey : String) : Bool
  {
    if(_localytics == null)
    {
      _localytics = _start(localyticsKey);
      return true;
    }
    else
    {
      return false;
    }
  }

  public function stop() : Bool
  {
    if(_localytics != null)
    {
      _stop();
      _localytics = null;
      return true;
    }
    else
    {
      return false;
    }
  }

  public function tagEvent(msg : String, ?params : Dynamic = null) : Bool
  {
    if(_localytics == null)
    {
      return false;
    }
    else if(params != null)
    {
      var map = new JNIHashMap();
      for(n in Reflect.fields(params))
      {
        map.put(n, Std.string(Reflect.field(params, n)));
      }

      callMethod(_tagEventParams, [_localytics, msg, map.getJNIObject()]);
    }
    else
    {
      callMethod(_tagEvent, [_localytics, msg]);
    }

    return true;
  }

  public function tagScreen(screen : String) : Bool
  {
    if(_localytics == null)
    {
      return false;
    }
    else
    {
      _tagScreen(_localytics, screen);
      return true;
    }
  }

  private static function getStaticMethod(pkg : String, name : String, sig : String) : Dynamic
  {
    var m = JNI.createStaticMethod(pkg, name, sig);
    if(m == null)
    {
      trace(["Can't find static JNI method", pkg, name, sig]);
    }

    return m;
  }

  private static function getMemberMethod(pkg : String, name : String, sig : String, ?useArray : Bool = false) : Dynamic
  {
    var m = JNI.createMemberMethod(pkg, name, sig, useArray);
    if(m == null)
    {
      trace(["Can't find member JNI method", pkg, name, sig]);
    }

    return m;
  }

  private static function callMethod(method : Dynamic, args : Array<Dynamic>)
  {
    if(method != null)
    {
      method(args);
    }
    else
    {
      trace("Method is null");
      trace(CallStack.toString(CallStack.callStack()));
    }
  }

  private static function initJNI()
  {
    if(_start == null)
    {
      _start = getStaticMethod("ru/zzzzzzerg/linden/Localytics", "start", "(Ljava/lang/String;)Lcom/localytics/android/LocalyticsSession;");
    }

    if(_stop == null)
    {
      _stop = getStaticMethod("ru/zzzzzzerg/linden/Localytics", "stop", "()V");
    }

    if(_tagEvent == null)
    {
      _tagEvent = getMemberMethod("com/localytics/android/LocalyticsSession", "tagEvent", "(Ljava/lang/String;)V", true);
      _tagEventParams = getMemberMethod("com/localytics/android/LocalyticsSession", "tagEvent", "(Ljava/lang/String;Ljava/util/Map;)V", true);
    }

    if(_tagScreen == null)
    {
      _tagScreen = getMemberMethod("com/localytics/android/LocalyticsSession", "tagScreen", "(Ljava/lang/String;)V");
    }
  }

  private static var _start : Dynamic = null;
  private static var _stop : Dynamic = null;
  private static var _tagEvent : Dynamic = null;
  private static var _tagEventParams : Dynamic = null;
  private static var _tagScreen : Dynamic = null;
}

typedef Localytics = LocalyticsImpl;

#else

class LocalyticsFallback
{
  public function new()
  {
  }

  public function start(localyticsKey : String) : Bool
  {
    return false;
  }

  public function stop() : Bool
  {
    return false;
  }

  public function tagEvent(msg : String, ?params : Dynamic = null) : Bool
  {
    return false;
  }

  public function tagScreen(screen : String) : Bool
  {
    return false;
  }

}

typedef Localytics = LocalyticsFallback;


#end
