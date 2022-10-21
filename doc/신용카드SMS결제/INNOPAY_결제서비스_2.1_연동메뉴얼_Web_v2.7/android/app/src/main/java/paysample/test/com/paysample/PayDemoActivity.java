package paysample.test.com.paysample;

/**
 * Created by infinishj on 2018-08-01.
 */

import  android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.webkit.CookieManager;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.Toast;

import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.List;


public class PayDemoActivity extends AppCompatActivity {

    public static final String TAG = "PaySample";
    private final       Handler  handler                 = new Handler();
    WebView wv_pay;
    ProgressBar progressBar;
    final String PAY_URL = "https://pg.innopay.co.kr/ipay/appLink.jsp"; //웹뷰 연동 파일

    //결제 결과 파라미터 상수 선언
    public static final String   RESULT_PAY_METHOD = "PayMethod";
    public static final String   RESULT_MID = "MID";
    public static final String   RESULT_TID = "TID";
    public static final String   RESULT_MALL_USER_ID = "mallUserID";
    public static final String   RESULT_AMT = "Amt";
    public static final String   RESULT_NAME = "name";
    public static final String   RESULT_GOODS_NAME = "GoodsName";
    public static final String   RESULT_OID = "OID";
    public static final String   RESULT_MOID = "MOID";
    public static final String   RESULT_AUTH_DATE = "AuthDate";
    public static final String   RESULT_AUTH_CODE = "AuthCode";
    public static final String   RESULT_RESULT_CODE = "ResultCode";
    public static final String   RESULT_RESULT_MSG = "ResultMsg";
    public static final String   RESULT_MALL_RESERVED = "MallReserved";
    public static final String   RESULT_FN_CD = "fn_cd";
    public static final String   RESULT_FN_NAME = "fn_name";
    public static final String   RESULT_CARD_QUOTA = "CardQuota";
    public static final String   RESULT_BUYER_EMAIL = "BuyerEmail";
    public static final String   RESULT_BUYER_AUTH_NUM = "BuyerAuthNum";
    public static final String   RESULT_ERROR_CODE = "ErrorCode";
    public static final String   RESULT_ERROR_MSG = "ErrorMsg";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //requestWindowFeature(Window.FEATURE_NO_TITLE);
        //getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN , WindowManager.LayoutParams.FLAG_FULLSCREEN); //
        setContentView(R.layout.activity_paydemo);
        wv_pay = (WebView) findViewById(R.id.activity_paydemo_webview);
        progressBar = new ProgressBar(this);

        WebSettings settings=wv_pay.getSettings();
        settings.setJavaScriptEnabled(true);
                                                                         //웹뷰 설정
        wv_pay.setWebChromeClient(new WebChromeClient());
        wv_pay.setWebViewClient(new PayDemoActivity.CustomWebViewClient());
        wv_pay.getSettings().setJavaScriptEnabled(true);
        wv_pay.getSettings().setSavePassword(false);
        wv_pay.getSettings().setDomStorageEnabled(true);
        wv_pay.getSettings().setUserAgentString(wv_pay.getSettings().getUserAgentString()+" Webv");
        wv_pay.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);
        wv_pay.setInitialScale(50);
        wv_pay.getSettings().setDefaultZoom(WebSettings.ZoomDensity.FAR);
        wv_pay.getSettings().setUseWideViewPort(true);
        wv_pay.getSettings().setLoadsImagesAutomatically(true);
        wv_pay.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);

        wv_pay.addJavascriptInterface(new PayBridge(), "PayAppBridge");

        //안드로이드 cookie 허용 설정
        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            wv_pay.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
            CookieManager cookieManager = CookieManager.getInstance();
            cookieManager.setAcceptCookie(true);
            cookieManager.setAcceptThirdPartyCookies(wv_pay, true);
        }

        wv_pay.getSettings().setUseWideViewPort(true);
        wv_pay.getSettings().setAllowFileAccess(true);
        wv_pay.getSettings().setLoadWithOverviewMode(true);
        wv_pay.setInitialScale(1);

        wv_pay.getSettings().setBuiltInZoomControls(false);//키보드 올라갈때 처리
        wv_pay.getSettings().setSupportZoom(false);//키보드 올라갈때 처리

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE))
            { WebView.setWebContentsDebuggingEnabled(true); }
        }

        Intent intent = getIntent();                                       //파라미터 전달
        String MID = intent.getExtras().getString("MID");
        String PayMethod = intent.getExtras().getString("PayMethod");
        String Moid = intent.getExtras().getString("Moid");
        String GoodsName = intent.getExtras().getString("GoodsName");
        String Amt = intent.getExtras().getString("Amt");
        String DutyFreeAmt = intent.getExtras().getString("DutyFreeAmt");
        String GoodsCnt = intent.getExtras().getString("GoodsCnt");
        String BuyerName = intent.getExtras().getString("BuyerName");
        String MallUserID = intent.getExtras().getString("MallUserID");
        String BuyerTel = intent.getExtras().getString("BuyerTel");
        String BuyerEmail = intent.getExtras().getString("BuyerEmail");
        String OfferingPeriod = intent.getExtras().getString("OfferingPeriod");
        String webview="webview";
        String MerchantKey = intent.getExtras().getString("MerchantKey");

        String postData = "&MID=" + MID + "&Moid=" + Moid + "&GoodsName=" + GoodsName + "&Amt=" + Amt + "&DutyFreeAmt=" + DutyFreeAmt + "&GoodsCnt=" + GoodsCnt + "&BuyerName=" + BuyerName + "&MallUserID=" + MallUserID + "&BuyerTel=" + BuyerTel + "&webview="+ webview +"&BuyerEmail=" + BuyerEmail + "&OfferingPeriod=" + OfferingPeriod + "&MerchantKey=" + MerchantKey + "&PayMethod="+PayMethod;
        wv_pay.postUrl(PAY_URL, postData.getBytes());


    }

    void toastMSG(String msg){
        Toast.makeText(this, msg , Toast.LENGTH_SHORT).show();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && wv_pay.canGoBack()) {
            wv_pay.goBack();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }


    private class CustomWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {   //해당 앱 설치 여부 판단 후 미설치 시 해당 마켓 플레이스로 보냄.
            if (url != null && url.startsWith("intent://")) {
                try {
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    Intent existPackage = getPackageManager().getLaunchIntentForPackage(intent.getPackage());
                    if (existPackage != null) {
                        startActivity(intent);
                    } else {
                        Intent marketIntent = new Intent(Intent.ACTION_VIEW);
                        marketIntent.setData(Uri.parse("market://details?id="+intent.getPackage()));
                        startActivity(marketIntent);
                    }
                    return true;
                }catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (url != null && url.startsWith("market://")) {
                try {
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    if (intent != null) {
                        startActivity(intent);
                    }
                    return true;
                } catch (URISyntaxException e) {
                    e.printStackTrace();
                }
            } else if (url != null && url != "ansimclick.hyundiacard.co"
                    && (url.contains("http://market.android.com")
                    || url.contains("vguard")
                    || url.contains("droidxantivirus")
                    || url.contains("smhyundaiansimclick://")
                    || url.contains("smshinhanansimclick://")
                    || url.contains("smshinhancardusim://")
                    || url.contains("smartwall://")
                    || url.contains("appfree://")
                    || url.contains("market://")
                    || url.contains("v3mobile") || url.endsWith(".apk")
                    || url.contains("tel:")
                    || url.contains("ansimclick") || url.contains("http://m.ahnlab.com/kr/site/download"))) {
                try {

                    // 인텐트 정합성 체크 : 2014 .01추가
                    Intent intent = null;
                    try {
                        intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                        Log.e("intent getScheme     >", intent.getScheme());
                        Log.e("intent getDataString >", intent.getDataString());
                    } catch (URISyntaxException ex) {
                        Log.e("Browser", "Bad URI " + url + ":" + ex.getMessage());
                        return false;
                    }
                    //chrome 버젼 방식 : 2014.01 추가
                    if (url.startsWith("intent")) { // chrome 버젼 방식
                        // 앱설치 체크를 합니다.
                        if (getPackageManager().resolveActivity(intent, 0) == null) {
                            String packagename = intent.getPackage();
                            if (packagename != null) {
                                Uri uri = Uri.parse("market://search?q=pname:"
                                        + packagename);
                                intent = new Intent(Intent.ACTION_VIEW, uri);
                                startActivity(intent);
                                return true;
                            }
                        }

                        //구동방식은 PG:쇼핑몰에서 결정하세요.
                        int runType=1;

                        if (runType == 1) {
                            Uri uri = Uri.parse(intent.getDataString());
                            intent = new Intent(Intent.ACTION_VIEW, uri);
                            startActivity(intent);
                        } else {
                            intent.addCategory(Intent.CATEGORY_BROWSABLE);
                            intent.setComponent(null);
                            try {
                                if (startActivityIfNeeded(intent, -1)) {
                                    return true;
                                }
                            } catch (ActivityNotFoundException ex) {
                                return false;
                            }
                        }
                    } else { // 구 방식
                        Uri uri = Uri.parse(url);
                        intent = new Intent(Intent.ACTION_VIEW, uri);
                        startActivity(intent);
                    }
                } catch (ActivityNotFoundException e) {
                    Log.e("error ===>", e.getMessage());
                    e.printStackTrace();
                    return false;
                }
            } else {
                view.loadUrl(url);
                return false;
            }
            return true;
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
            progressBar.setVisibility(View.VISIBLE);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            progressBar.setVisibility(View.GONE);
        }

        @Override
        public void onReceivedError(WebView view, int errorCode,
                                    String description, String failingUrl) {
            progressBar.setVisibility(View.GONE);
            Toast.makeText(PayDemoActivity.this , failingUrl + " 접근시도에 실패하엿습니다." , Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onReceivedSslError(WebView view, final SslErrorHandler handler, SslError error) {
            // TODO Auto-generated method stub
            final AlertDialog.Builder builder = new AlertDialog.Builder(getApplicationContext());
            builder.setMessage("유효하지 않는 인증서 입니다.\\n무시하고 진행을 원하시면 진행 \\n취소하고싶으면 취소버튼을 눌러주세요.");
            builder.setPositiveButton("진행", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    handler.proceed();
                }
            });
            builder.setNegativeButton("취소", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    handler.cancel();
                }
            });
            final AlertDialog dialog = builder.create();
            dialog.show();
        }

    }
//자바스크립트 브릿지
    private class PayBridge
    {
        @JavascriptInterface
        public void PayResult(final String msg){
            Log.d(TAG, msg);
            finishActivity(msg);
        }
        @JavascriptInterface
        public void backpage() //자바스크립트에서 네이티브 앱 결제창 호출 코드
        {
            Intent intent= new Intent(getApplicationContext(), MainActivity.class);
            startActivity(intent);
        }
    }

    public void finishActivity( String p_strFinishMsg )  //결제 결과 수신 코드
    {
        Intent intent = new Intent();

        if ( p_strFinishMsg != null )
        {
            try {
                JSONObject resultData = new JSONObject(p_strFinishMsg);
                intent.putExtra( RESULT_PAY_METHOD, resultData.optString(RESULT_PAY_METHOD) );
                intent.putExtra( RESULT_MID, resultData.optString(RESULT_MID) );
                intent.putExtra( RESULT_TID, resultData.optString(RESULT_TID) );
                intent.putExtra( RESULT_MALL_USER_ID, resultData.optString(RESULT_MALL_USER_ID) );
                intent.putExtra( RESULT_AMT, resultData.optString(RESULT_AMT) );
                intent.putExtra( RESULT_NAME, resultData.optString(RESULT_NAME) );
                intent.putExtra( RESULT_GOODS_NAME, resultData.optString(RESULT_GOODS_NAME) );
                intent.putExtra( RESULT_OID, resultData.optString(RESULT_OID) );
                intent.putExtra( RESULT_MOID, resultData.optString(RESULT_MOID) );
                intent.putExtra( RESULT_AUTH_DATE, resultData.optString(RESULT_AUTH_DATE) );
                intent.putExtra( RESULT_AUTH_CODE, resultData.optString(RESULT_AUTH_CODE) );
                intent.putExtra( RESULT_RESULT_CODE, resultData.optString(RESULT_RESULT_CODE) );
                intent.putExtra( RESULT_RESULT_MSG, resultData.optString(RESULT_RESULT_MSG) );
                intent.putExtra( RESULT_MALL_RESERVED, resultData.optString(RESULT_MALL_RESERVED) );
                intent.putExtra( RESULT_FN_CD, resultData.optString(RESULT_FN_CD) );
                intent.putExtra( RESULT_FN_NAME, resultData.optString(RESULT_FN_NAME) );
                intent.putExtra( RESULT_CARD_QUOTA, resultData.optString(RESULT_CARD_QUOTA) );
                intent.putExtra( RESULT_BUYER_EMAIL, resultData.optString(RESULT_BUYER_EMAIL) );
                intent.putExtra( RESULT_BUYER_AUTH_NUM, resultData.optString(RESULT_BUYER_AUTH_NUM) );
                intent.putExtra( RESULT_ERROR_CODE, resultData.optString(RESULT_ERROR_CODE) );
                intent.putExtra( RESULT_ERROR_MSG, resultData.optString(RESULT_ERROR_MSG) );
            }catch (Exception e){
                Log.e(TAG, e.getMessage());
            }

            setResult( RESULT_OK, intent );
        }
        else
        {
            setResult( RESULT_CANCELED );
        }
        finish();
    }
}
