package ru.zzzzzzerg.linden;

import android.content.Context;
import android.util.Log;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import com.localytics.android.LocalyticsSession;
import org.haxe.extension.Extension;

public class Localytics extends Extension
{
  private static String tag = "LindenLocalytics";
  private static LocalyticsSession localytics = null;

  public Localytics()
  {
    Log.d(tag, "Construct LindenLocalytics");
  }

  /**
   * Called when an activity you launched exits, giving you the requestCode
   * you started it with, the resultCode it returned, and any additional data
   * from it.
   */
  public boolean onActivityResult (int requestCode, int resultCode, Intent data)
  {
    return true;
  }


  /**
   * Called when the activity is starting.
   */
  public void onCreate(Bundle savedInstanceState)
  {
  }


  /**
   * Perform any final cleanup before an activity is destroyed.
   */
  public void onDestroy()
  {
  }


  /**
   * Called as part of the activity lifecycle when an activity is going into
   * the background, but has not (yet) been killed.
   */
  public void onPause()
  {
    if(localytics != null)
    {
      Log.d(tag, "Pausing LindenLocalytics");
      localytics.close();
      localytics.upload();
      Log.d(tag, "LindenLocalytics paused");
    }
  }


  /**
   * Called after {@link #onStop} when the current activity is being
   * re-displayed to the user (the user has navigated back to it).
   */
  public void onRestart()
  {
  }


  /**
   * Called after {@link #onRestart}, or {@link #onPause}, for your activity
   * to start interacting with the user.
   */
  public void onResume()
  {
    if(localytics != null)
    {
      Log.d(tag, "Resuming LindenLocalytics");
      localytics.open();
      Log.d(tag, "LindenLocalytics resumed");
    }
  }


  /**
   * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when
   * the activity had been stopped, but is now again being displayed to the
   * user.
   */
  public void onStart()
  {
  }


  /**
   * Called when the activity is no longer visible to the user, because
   * another activity has been resumed and is covering this one.
   */
  public void onStop()
  {
  }

  public static LocalyticsSession start(String localyticsKey)
  {
    if(localytics == null)
    {
      Log.d(tag, "Creating LindenLocalytics");
      localytics = new LocalyticsSession(mainContext, localyticsKey);
    }
    else
    {
      Log.d(tag, "LindenLocalytics already created");
    }

    Log.d(tag, "Starting LindenLocalytics");

    localytics.open();
    localytics.upload();

    Log.d(tag, "LindenLocalytics started");

    return localytics;
  }

  public static void stop()
  {
    if(localytics != null)
    {
      Log.d(tag, "Closing LindenLocalytics");

      localytics.close();
      localytics.upload();

      localytics = null;

      Log.d(tag, "LindenLocalytics closed");
    }
  }

}
