<%@ page  contentType="text/html; charset=euc-kr" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.Calendar" %>
<%
/*******************************************************************************
 * FILE NAME : InnopayPgNoti_JSP.jsp
 * DATE : 2015.03.18
*******************************************************************************/

/*******************************************************************************
 * 변수명           한글명
 *--------------------------------------------------------------------------------
 ********************************************************************************
 * 공통
 ********************************************************************************
 * transSeq			거래번호
 * userId			사용자아이디
 * userName			사용자이름
 * userPhoneNo		사용자휴대폰번호
 * moid				주문번호
 * goodsName		상품명
 * goodsAmt			상품금액
 * buyerName		구매자명
 * buyerPhoneNo		구매자휴대폰번호
 * pgCode			PG코드 ( 01:NICE / 02:KICC / 03:INFINISOFT / 04:KSNET / 05:KCP / 06:SMATRO )
 * pgName			PG명
 * payMethod		결제수단( 01:현금결제 / 02:신용카드 / 03:신용카드ARS )
 * payMethodName	결제수단명
 * pgMid			PG아이디
 * pgSid			PG서비스아이디
 * status			거래상태 ( 25:결제완료 / 85:결제취소 )
 * statusName		거래상태명
 * pgResultCode		PG결과코드
 * pgResultMsg		PG결과메세지
 * pgAppDate		PG승인일자
 * pgAppTime		PG승인시간
 * pgTid			PG거래번호
 * approvalAmt		승인금액
 * approvalNo		승인번호
 ********************************************************************************
 * 현글결제(현금영수증)
 ********************************************************************************
 * cashReceiptType			증빙구분 ( 1:소득공제 / 2:지출증빙 )
 * cashReceiptTypeName		증빙구분명
 * cashReceiptSupplyAmt		공급가
 * cashReceiptVat			부가세
 ********************************************************************************
 * 신용카드결제
 ********************************************************************************
 * cardNo					카드번호
 * cardQuota				할부개월
 * cardIssueCode			발급사코드 ( 메뉴얼참조 )
 * cardIssueName			발급사명
 * cardAcquireCode			매입사코드 ( 메뉴얼참조 )
 * cardAcquireName			매입사명
 ********************************************************************************
 * 결제취소
 ********************************************************************************
 * cancelAmt				취소요청금액
 * cancelMsg				취소요청메세지
 * cancelResultCode			취소결과코드
 * cancelResultMsg			취소결과메세지
 * cancelAppDate			취소승인일자
 * cancelAppTime			취소승인시간
 * cancelPgTid				PG거래번호
 * cancelApprovalAmt		승인금액
 * cancelApprovalNo			승인번호
*******************************************************************************/

/***********************************************************************************
 * 인피니소프트가 전달하는 ARS 결제 결과를 수신하여 DB 처리 하는 부분 입니다.	
 * 필요한 파라메터에 대한 DB 작업을 수행하십시오.
 ***********************************************************************************/	
		
/**********************************************************************************
    이부분에 로그파일 경로를 수정해주세요.*/
		String log_path = "c:/infinisoft";
/**********************************************************************************/
		String add = request.getRemoteAddr().toString();
		
		
		transSeq     	= request.getParameter("transSeq");
		userId       	= request.getParameter("userId");
		userName		= request.getParameter("userName");
		userPhoneNo     = request.getParameter("userPhoneNo");
		moid        	= request.getParameter("moid");
		goodsName   	= request.getParameter("goodsName");
		goodsAmt   		= request.getParameter("goodsAmt");
		buyerName  		= request.getParameter("buyerName");
		buyerPhoneNo   	= request.getParameter("buyerPhoneNo");
		pgCode    		= request.getParameter("pgCode");
		pgName  		= request.getParameter("pgName");
		payMethod   	= request.getParameter("payMethod");
		payMethodName	= request.getParameter("payMethodName");
		pgMid   		= request.getParameter("pgMid");
		pgSid			= request.getParameter("pgSid");
		status    		= request.getParameter("status");
		statusName		= request.getParameter("statusName");
		pgResultCode   	= request.getParameter("pgResultCode");
		pgResultMsg   	= request.getParameter("pgResultMsg");
		pgAppDate     	= request.getParameter("pgAppDate");
		pgAppTime     	= request.getParameter("pgAppTime");
		pgTid			= request.getParameter("pgTid");
		approvalAmt		= request.getParameter("approvalAmt");
		approvalNo		= request.getParameter("approvalNo");
		
		if("01".equals(payMethod)){
			//현금결제(현금영수증)
			cashReceiptType			= request.getParameter("cashReceiptType");
			cashReceiptTypeName		= request.getParameter("cashReceiptTypeName");
			cashReceiptSupplyAmt	= request.getParameter("cashReceiptSupplyAmt");
			cashReceiptVat			= request.getParameter("cashReceiptVat");

		}else if("02".equals(payMethod) || "03".equals(payMethod)){
			//신용카드 & 신용카드ARS
			cardNo				= request.getParameter("cardNo");
			cardQuota			= request.getParameter("cardQuota");
			cardIssueCode		= request.getParameter("cardIssueCode");
			cardIssueName		= request.getParameter("cardIssueName");
			cardAcquireCode		= request.getParameter("cardAcquireCode");
			cardAcquireName		= request.getParameter("cardAcquireName");
		}


		if("85".equals(status)){
			//결제취소
			cancelAmt			= request.getParameter("cancelAmt");
			cancelMsg			= request.getParameter("cancelMsg");
			cancelResultCode	= request.getParameter("cancelResultCode");
			cancelResultMsg		= request.getParameter("cancelResultMsg");
			cancelAppDate		= request.getParameter("cancelAppDate");
			cancelAppTime		= request.getParameter("cancelAppTime");
			cancelPgTid			= request.getParameter("cancelPgTid");
			cancelApprovalAmt	= request.getParameter("cancelApprovalAmt");
			cancelApprovalNo	= request.getParameter("cancelApprovalNo");
		}
		
		//상품 정보가 추가될 경우 (주석제거)
		//goodsSize				= request.getParameter("goodsSize");
		//goodsCodeArray		= request.getParameter("goodsCodeArray");
		//goodsNameArray		= request.getParameter("goodsNameArray");
		//goodsAmtArray			= request.getParameter("goodsAmtArray");
		//goodsCntArray			= request.getParameter("goodsCntArray");
		//totalAmtArray			= request.getParameter("totalAmtArray");

		//배송지 정보가 추가될 경우 (주석제거)
		//zoneCode				= request.getParameter("zoneCode");
		//address				= request.getParameter("address");
		//addressDetail			= request.getParameter("addressDetail");
		//recipientName			= request.getParameter("recipientName");
		//recipientPhoneNo		= request.getParameter("recipientPhoneNo");
		//comment				= request.getParameter("comment");
		
		try
		{
			writeLog(log_path);

//***********************************************************************************
//
//	위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를 인피니로
//	리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
//	(주의) OK를 리턴하지 않으시면 인피니 지불 서버는 "OK"를 수신할때까지 계속 재전송(지정된 최대횟수까지)을 시도합니다
//	기타 다른 형태의 out.println(response.write)는 하지 않으시기 바랍니다
//	if (데이터베이스 등록 성공 유무 조건변수 = true) 
//  {
    	out.print("0000"); // 절대로 지우지 마세요
//  }
		}
		catch(Exception e)
		{
			out.print(e.getMessage());
		}
%>
<%!

	private String transSeq   			;
	private String userId     			;
	private String userName	 			;
	private String userPhoneNo			;
	private String moid      			;
	private String goodsName 			;
	private String goodsAmt 			;
	private String buyerName			;
	private String buyerPhoneNo 		;
	private String pgCode  				;
	private String pgName				;
	private String payMethod 			;
	private String payMethodName		;
	private String pgMid 				;
	private String pgSid				;
	private String status  				;
	private String statusName  			;
	private String pgResultCode 		;
	private String pgResultMsg 			;
	private String pgAppDate   			;
	private String pgAppTime   			;
	private String pgTid 				;
	private String approvalAmt 			;
	private String approvalNo 			;
	
	//현금결제(현금영수증)
	private String cashReceiptType 		;
	private String cashReceiptTypeName 	;
	private String cashReceiptSupplyAmt	;
	private String cashReceiptVat 		;
	
	//신용카드 & 신용카드ARS
	private String cardNo 				;
	private String cardQuota 			;
	private String cardIssueCode 		;
	private String cardIssueName 		;
	private String cardAcquireCode 		;
	private String cardAcquireName 		;
	
	//결제취소
	private String cancelAmt 			;
	private String cancelMsg 			;
	private String cancelResultCode 	;
	private String cancelResultMsg 		;
	private String cancelAppDate 		;
	private String cancelAppTime 		;
	private String cancelPgTid 			;
	private String cancelApprovalAmt 	;
	private String cancelApprovalNo 	;
	
	//상품 정보가 추가될 경우 (주석제거)
	//private String goodsSize			;
	//private String goodsCodeArray		;
	//private String goodsNameArray		;
	//private String goodsAmtArray		;
	//private String goodsCntArray		;
	//private String totalAmtArray		;

	//배송지 정보가 추가될 경우 (주석제거)
	//private String zoneCode			;
	//private String address			;
	//private String addressDetail		;
	//private String recipientName		;
	//private String recipientPhoneNo	;
	//private String comment			;
	
	private StringBuffer times			;
    private String getDate()
    {
    	Calendar calendar = Calendar.getInstance();
    	
    	times = new StringBuffer();
        times.append(Integer.toString(calendar.get(Calendar.YEAR)));
		if((calendar.get(Calendar.MONTH)+1)<10)
        { 
            times.append("0"); 
        }
		times.append(Integer.toString(calendar.get(Calendar.MONTH)+1));
		if((calendar.get(Calendar.DATE))<10) 
        { 
            times.append("0");	
        } 
		times.append(Integer.toString(calendar.get(Calendar.DATE)));
    	
    	return times.toString();
    }
    
    private String getTime()
    {
    	Calendar calendar = Calendar.getInstance();
    	
    	times = new StringBuffer();

    	times.append("[");
    	if((calendar.get(Calendar.HOUR_OF_DAY))<10) 
        { 
            times.append("0"); 
        } 
 		times.append(Integer.toString(calendar.get(Calendar.HOUR_OF_DAY)));
 		times.append(":");
 		if((calendar.get(Calendar.MINUTE))<10) 
        { 
            times.append("0"); 
        }
 		times.append(Integer.toString(calendar.get(Calendar.MINUTE)));
 		times.append(":");
 		if((calendar.get(Calendar.SECOND))<10) 
        { 
            times.append("0"); 
        }
 		times.append(Integer.toString(calendar.get(Calendar.SECOND)));
 		times.append("]");
 		
 		return times.toString();
    }

    private void writeLog(String log_path) throws Exception
    {

        File file = new File(log_path);
        file.createNewFile();

        FileWriter file2 = new FileWriter(log_path+"/infini_ars_recv_"+getDate()+".log", true);


		file2.write("\n************************************************\n");
		file2.write("PageCall time    : " + getTime());
		file2.write("\ntransSeq       : " + transSeq   ); 
		file2.write("\nuserId         : " + userId     );
		file2.write("\nuserName       : " + userName    ); 
		file2.write("\nuserPhoneNo    : " + userPhoneNo     ); 
		file2.write("\nmoid           : " + moid      );
		file2.write("\ngoodsName      : " + goodsName );
		file2.write("\ngoodsAmt       : " + goodsAmt );
		file2.write("\nbuyerName      : " + buyerName); 
		file2.write("\nbuyerPhoneNo   : " + buyerPhoneNo ); 
		file2.write("\npgCode         : " + pgCode  ); 
		file2.write("\npgName         : " + pgName); 
		file2.write("\npayMethod      : " + payMethod ); 
		file2.write("\npayMethodName  : " + payMethodName    ); 
		file2.write("\npgMid          : " + pgMid );
		file2.write("\npgSid          : " + pgSid );
		file2.write("\nstatus         : " + status  ); 
		file2.write("\nstatusName     : " + statusName  ); 
		file2.write("\npgResultCode   : " + pgResultCode ); 
		file2.write("\npgResultMsg    : " + pgResultMsg ); 
		file2.write("\npgAppDate      : " + pgAppDate   ); 
		file2.write("\npgAppTime      : " + pgAppTime   );  
		file2.write("\npgTid          : " + pgTid   );
		file2.write("\napprovalAmt    : " + approvalAmt   );
		file2.write("\napprovalNo     : " + approvalNo   );
		
		
		if("01".equals(payMethod)){
			//현금결제(현금영수증)
			file2.write("\ncashReceiptType     	: " + cashReceiptType   );
			file2.write("\ncashReceiptTypeName  : " + cashReceiptTypeName   );
			file2.write("\ncashReceiptSupplyAmt	: " + cashReceiptSupplyAmt   );
			file2.write("\ncashReceiptVat     	: " + cashReceiptVat   );
			
		}else if("02".equals(payMethod) || "03".equals(payMethod)){
			//신용카드 & 신용카드ARS
			file2.write("\ncardNo     			: " + cardNo   );
			file2.write("\ncardQuota     		: " + cardQuota   );
			file2.write("\ncardIssueCode     	: " + cardIssueCode   );
			file2.write("\ncardIssueName     	: " + cardIssueName   );
			file2.write("\ncardAcquireCode     	: " + cardAcquireCode   );
			file2.write("\ncardAcquireName     	: " + cardAcquireName   );
		}


		if("85".equals(status)){
			//결제취소
			file2.write("\ncancelAmt     		: " + cancelAmt   );
			file2.write("\ncancelMsg     		: " + cancelMsg   );
			file2.write("\ncancelResultCode     : " + cancelResultCode   );
			file2.write("\ncancelResultMsg     	: " + cancelResultMsg   );
			file2.write("\ncancelAppDate     	: " + cancelAppDate   );
			file2.write("\ncancelAppTime     	: " + cancelAppTime   );
			file2.write("\ncancelPgTid     		: " + cancelPgTid   );
			file2.write("\ncancelApprovalAmt    : " + cancelApprovalAmt   );
			file2.write("\ncancelApprovalNo     : " + cancelApprovalNo   );
		}
		
		//상품 정보가 추가될 경우 (주석제거)
		//file2.write("\ngoodsSize     			: " + goodsSize);
		//file2.write("\ngoodsCodeArray     	: " + goodsCodeArray);
		//file2.write("\ngoodsNameArray     	: " + goodsNameArray);
		//file2.write("\ngoodsAmtArray     		: " + goodsAmtArray);
		//file2.write("\ngoodsCntArray     		: " + goodsCntArray);
		//file2.write("\ntotalAmtArray     		: " + totalAmtArray	);

		//배송지 정보가 추가될 경우 (주석제거)
		//file2.write("\nzoneCode     			: " + zoneCode);
		//file2.write("\naddress     			: " + address);
		//file2.write("\naddressDetail     		: " + addressDetail);
		//file2.write("\nrecipientName     		: " + recipientName);
		//file2.write("\nrecipientPhoneNo     	: " + recipientPhoneNo);
		//file2.write("\ncomment     			: " + comment);
		
		file2.write("\n************************************************\n");

        file2.close();

    }
%>
