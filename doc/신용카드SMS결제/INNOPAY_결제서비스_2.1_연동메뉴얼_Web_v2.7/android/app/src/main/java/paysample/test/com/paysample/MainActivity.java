package paysample.test.com.paysample;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;

public class MainActivity extends AppCompatActivity {

    public static final String TAG = "PaySample2";
    private Button startPay;
    private EditText Moid, GoodsName, Amt, DutyFreeAmt, GoodsCnt, BuyerName, MallUserID, BuyerTel, BuyerEmail, OfferingPeriod, MID;
    private Spinner MethodSpinner;

    private static final int    ACTIVITY_PAYDEMO    = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN , WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_main);



        startPay = (Button) findViewById(R.id.startPay);

        startPay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(MainActivity.this, PayDemoActivity.class);
                intent.putExtra("MID", MID.getText().toString());   //발급 받은 mid 입력
                intent.putExtra("Moid", Moid.getText().toString());
                intent.putExtra("GoodsName", GoodsName.getText().toString());
                intent.putExtra("Amt", Amt.getText().toString());
                intent.putExtra("DutyFreeAmt", DutyFreeAmt.getText().toString());
                intent.putExtra("PayMethod", MethodSpinner.getSelectedItem().toString());
                intent.putExtra("GoodsCnt", GoodsCnt.getText().toString());
                intent.putExtra("BuyerName", BuyerName.getText().toString());
                intent.putExtra("MallUserID", MallUserID.getText().toString());
                intent.putExtra("BuyerTel", BuyerTel.getText().toString());
                intent.putExtra("BuyerEmail", BuyerEmail.getText().toString());
                intent.putExtra("OfferingPeriod", OfferingPeriod.getText().toString());
                String MerchantKey = "Ma29gyAFhvv/+e4/AHpV6pISQIvSKziLIbrNoXPbRS5nfTx2DOs8OJve+NzwyoaQ8p9Uy1AN4S1I0Um5v7oNUg=="; //발급받은 라이센스키 입력
                MerchantKey = MerchantKey.replaceAll("\\+", "%2B"); // + 기호 치환
                MerchantKey = MerchantKey.replaceAll(" ", "+"); // + 기호 치환
                intent.putExtra("MerchantKey", MerchantKey);
                startActivityForResult( intent, ACTIVITY_PAYDEMO );
            }
        });

        SimpleDateFormat dateFormat = new  SimpleDateFormat("yyyyMMddHHmmss", java.util.Locale.getDefault());
        Date date = new Date();
        String strDate = dateFormat.format(date);
        MID = (EditText) findViewById(R.id.MID);
        MethodSpinner = (Spinner)findViewById(R.id.PayMethod);
        Moid = (EditText) findViewById(R.id.Moid);
        GoodsName = (EditText) findViewById(R.id.GoodsName);
        Amt = (EditText) findViewById(R.id.Amt);
        DutyFreeAmt = (EditText) findViewById(R.id.DutyFreeAmt);
        GoodsCnt = (EditText) findViewById(R.id.GoodsCnt);
        BuyerName = (EditText) findViewById(R.id.BuyerName);
        MallUserID = (EditText) findViewById(R.id.MallUserID);
        BuyerTel = (EditText) findViewById(R.id.BuyerTel);
        BuyerEmail = (EditText) findViewById(R.id.BuyerEmail);
        OfferingPeriod = (EditText) findViewById(R.id.OfferingPeriod);

        Moid.setText("test" + strDate);
        ArrayAdapter MethodAdapter = ArrayAdapter.createFromResource(this,
                R.array.PayMethod, android.R.layout.simple_spinner_item);
        MethodAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        MethodSpinner.setAdapter(MethodAdapter);
    }
    void toastMSG(String msg){
        Toast.makeText(this, msg , Toast.LENGTH_SHORT).show();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {

            AlertDialog.Builder dialog = new AlertDialog.Builder(this);
            dialog.setMessage("프로그램을 종료하시겠습니까?");
            dialog.setCancelable(true);
            dialog.setPositiveButton("확인", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    finish();
                }
            });
            dialog.setNegativeButton("취소", null);
            dialog.show();

            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void    onActivityResult( int     p_requestCode,
                                        int     p_resultCode,
                                        Intent  p_intentActivity )
    {
        if ( p_requestCode == ACTIVITY_PAYDEMO )
        {
            if ( p_resultCode == RESULT_OK )    //결제 결과를 성공적으로 받았을 경우
            {
                /*
                    사용자 환경에 따라 결제 결과를 받지 못하는 경우가 발생될 수 있으니
                    "InnopayPgNoti 메뉴얼" 가이드 문서를 참조하여 결제 결과 수신을 필수로 구현하여야 합니다.
                 */
                String resultCode = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_RESULT_CODE ); //결과코드
                String resultMsg = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_RESULT_MSG ); //결과메시지
                String payMethod = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_PAY_METHOD ); //지불수단 CARD:신용카드, BANK:계좌이체, VBANK:가상계좌
                String mid = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_MID ); //상점ID
                String tid = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_TID ); //거래번호
                String mallUserId = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_MALL_USER_ID ); //고객사회원ID
                String Amt = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_AMT ); //금액
                String name = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_NAME ); //결제자명
                String goodsName = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_GOODS_NAME ); //상품명
                String oid = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_OID ); //주문번호(OID, MOID 동일)
                String moid = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_MOID ); //주문번호(OID, MOID 동일)
                String authDate = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_AUTH_DATE ); //승인일자 yymmddhhmmss
                String authCode = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_AUTH_CODE ); //승인번호
                String mallReserved = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_MALL_RESERVED ); //상점예비정보
                String fnCd = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_FN_CD ); //결제카드사코드
                String fnName = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_FN_NAME ); //결제카드사명
                String cardQuota = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_CARD_QUOTA); //할부개월수
                String buyerEmail = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_BUYER_EMAIL ); //구매자이메일주소
                String buyerAuthNum = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_BUYER_AUTH_NUM ); //구매자이메일주소
                String errorCode = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_ERROR_CODE ); //구매자이메일주소
                String errorMsg = p_intentActivity.getExtras().getString( PayDemoActivity.RESULT_ERROR_MSG ); //구매자이메일주소

                /*
                    가맹점 처리 구간
                */

                Log.d( TAG, "[Sample] resultCode: " + resultCode );   // 결제 결과 파라미터로그 출력
                Log.d( TAG, "[Sample] resultMsg: " + resultMsg );
                Log.d( TAG, "[Sample] payMethod: " + payMethod );
                Log.d( TAG, "[Sample] mid: " + mid );
                Log.d( TAG, "[Sample] tid: " + tid );
                Log.d( TAG, "[Sample] mallUserId: " + mallUserId );
                Log.d( TAG, "[Sample] Amt: " + Amt );
                Log.d( TAG, "[Sample] name: " + name );
                Log.d( TAG, "[Sample] goodsName: " + goodsName );
                Log.d( TAG, "[Sample] oid: " + oid );
                Log.d( TAG, "[Sample] moid: " + moid );
                Log.d( TAG, "[Sample] authDate: " + authDate );
                Log.d( TAG, "[Sample] authCode: " + authCode );
                Log.d( TAG, "[Sample] mallReserved: " + mallReserved );
                Log.d( TAG, "[Sample] fnCd: " + fnCd );
                Log.d( TAG, "[Sample] fnName: " + fnName );
                Log.d( TAG, "[Sample] cardQuota: " + cardQuota );
                Log.d( TAG, "[Sample] buyerEmail: " + buyerEmail );
                Log.d( TAG, "[Sample] buyerAuthNum: " + buyerAuthNum );
                Log.d( TAG, "[Sample] errorCode: " + errorCode );
                Log.d( TAG, "[Sample] errorMsg: " + errorMsg );

                toastMSG( resultCode );
                toastMSG( resultMsg );
            }
            else    //결제 결과를 받지 못할 경우
            {
                /*
                    가맹점 처리 구간
                */

                toastMSG( "결과 알수 없음 (취소 또는 오류 발생)" );
            }
        }
        else
        {
            super.onActivityResult( p_requestCode, p_resultCode, p_intentActivity );
        }
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        Log.d( TAG, "[Sample] event__onStart" );
    }

    @Override
    protected void onRestart()
    {
        super.onRestart();

        Log.d( TAG, "[Sample] event__onReStart" );
    }

    @Override
    protected void onResume()
    {
        super.onResume();

        Log.d( TAG, "[Sample] event__onResume" );
    }

    @Override
    protected void onPause()
    {
        Log.d( TAG, "[Sample] event__onPause" );

        super.onPause();
    }

    @Override
    protected void onStop()
    {
        Log.d( TAG, "[Sample] event__onStop" );

        super.onStop();
    }

    @Override
    protected void onDestroy()
    {
        Log.d( TAG, "[Sample] event__onDestroy" );

        super.onDestroy();
    }
}
