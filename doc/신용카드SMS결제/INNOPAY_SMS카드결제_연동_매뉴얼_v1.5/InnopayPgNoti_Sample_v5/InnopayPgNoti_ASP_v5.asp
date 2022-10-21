<%@Language="VBScript" CODEPAGE="949" %>
<% 

Response.CharSet="euc-kr"
Session.codepage="949"
Response.codepage="949"
Response.ContentType="text/html;charset=euc-kr"

'*******************************************************************************
' * FILE NAME : InnopayPgNoti_ASP.asp
' * DATE : 2017.01
' * =============================================================================
' * 변수명                              한글명
' * =============================================================================
' * transSeq           거래번호 (20)
' * userId             사용자아이디 (40)
' * userName           사용자이름 
' * userPhoneNo        사용자휴대폰번호 (40)
' * moid               주문번호 (100)
' * goodsName          상품명 (100)
' * goodsAmt           상품금액 (11)
' * buyerName          구매자명 (100)
' * buyerPhoneNo       구매자휴대폰번호 (40)
' * pgCode             PG코드 (6)
' * pgName             PG명 (20)
' * payMethod          결제수단( 01:현금결제 / 02:신용카드 / 03:신용카드ARS ) (6)
' * payMethodName      결제수단명 (20)
' * pgMid              PG아이디 (40)
' * pgSid	           PG서비스아이디 (40)
' * status             거래상태 ( 25:결제완료 / 85:결제취소 ) (6)
' * statusName         거래상태명 (20)
' * pgResultCode       PG결과코드 (10)
' * pgResultMsg        PG결과메세지 (100)
' * pgAppDate          PG승인일자 (10)
' * pgAppTime          PG승인시간 (10)
' * pgTid              PG거래번호 (50)
' * approvalAmt        승인금액 (11)
' * approvalNo         승인번호 (10)
' * ===================================================
' * 승인 추가정보
' * ===================================================
' * cardNo             카드번호 (16)
' * cardQuota          할부개월 (2)
' * cardIssueCode      발급사코드 ( 메뉴얼참조 ) (2)
' * cardIssueName      발급사명 (10)
' * cardAcquireCode    매입사코드 ( 메뉴얼참조 ) (2)
' * cardAcquireName    매입사명 (10)
' * ===================================================
' * 결제취소 시 ( status = 85 일 경우 )
' * ===================================================
' * cancelAmt          취소요청금액 (11)
' * cancelMsg          취소요청메세지 (100)
' * cancelResultCode   취소결과코드 (10)
' * cancelResultMsg    취소결과메세지 (100)
' * cancelAppDate      취소승인일자 (10)
' * cancelAppTime      취소승인시간 (10)
' * cancelPgTid        PG거래번호 (50)
' * cancelApprovalAmt  승인금액 (11)
' * cancelApprovalNo   승인번호 (10)
'*******************************************************************************/

TEMP_IP = Request.ServerVariables("REMOTE_ADDR")
PG_IP	= Left(TEMP_IP,14)

transSeq           = Request("transSeq")
userId             = Request("userId")
userName           = Request("userName")
userPhoneNo        = Request("userPhoneNo")
moid               = Request("moid")
goodsName          = Request("goodsName")
goodsAmt           = Request("goodsAmt")
buyerName          = Request("buyerName")
buyerPhoneNo       = Request("buyerPhoneNo")
pgCode             = Request("pgCode")
pgName             = Request("pgName")
payMethod          = Request("payMethod")
payMethodName      = Request("payMethodName")
pgMid              = Request("pgMid")
pgSid              = Request("pgSid")
status             = Request("status")
statusName         = Request("statusName")
pgResultCode       = Request("pgResultCode")
pgResultMsg        = Request("pgResultMsg")
pgAppDate          = Request("pgAppDate")
pgAppTime          = Request("pgAppTime")
pgTid              = Request("pgTid")
approvalAmt        = Request("approvalAmt")
approvalNo         = Request("approvalNo")
cardNo             = Request("cardNo")
cardQuota          = Request("cardQuota")
cardIssueCode      = Request("cardIssueCode")
cardIssueName      = Request("cardIssueName")
cardAcquireCode    = Request("cardAcquireCode")
cardAcquireName    = Request("cardAcquireName")

If payMethod = "01" Then
	cashReceiptType		= Request("cashReceiptType")
	cashReceiptTypeName	= Request("cashReceiptTypeName")
	cashReceiptSupplyAmt= Request("cashReceiptSupplyAmt")
	cashReceiptVat		= Request("cashReceiptVat")
ElseIf payMethod = "02" OR payMethod = "03" Then
	cardNo				= Request("cardNo")
	cardQuota			= Request("cardQuota")
	cardIssueCode		= Request("cardIssueCode")
	cardIssueName		= Request("cardIssueName")
	cardAcquireCode		= Request("cardAcquireCode")
	cardAcquireName		= Request("cardAcquireName")
End If

If status = "85" Then
	cancelAmt          = Request("cancelAmt")
	cancelMsg          = Request("cancelMsg")
	cancelResultCode   = Request("cancelResultCode")
	cancelResultMsg    = Request("cancelResultMsg")
	cancelAppDate      = Request("cancelAppDate")
	cancelAppTime      = Request("cancelAppTime")
	cancelPgTid        = Request("cancelPgTid")
	cancelApprovalAmt  = Request("cancelApprovalAmt")
	cancelApprovalNo   = Request("cancelApprovalNo")
End If

'상품 정보가 추가될 경우 (주석제거)
'goodsSize          		= Request("goodsSize")
'goodsCodeArray          	= Request("goodsCodeArray")
'goodsNameArray          	= Request("goodsNameArray")
'goodsAmtArray           	= Request("goodsAmtArray")
'goodsCntArray           	= Request("goodsCntArray")
'totalAmtArray           	= Request("totalAmtArray")

'배송지 정보가 추가될 경우 (주석제거)
'zoneCode          			= Request("zoneCode")
'address          			= Request("address")
'addressDetail          	= Request("addressDetail")
'recipientName          	= Request("recipientName")
'recipientPhoneNo       	= Request("recipientPhoneNo")
'comment          			= Request("comment")


'**********************************************************************************
Set objFSO = CreateObject("Scripting.FileSystemObject")
'   폴더가 없을경우 폴더를 새로 만들고
'   파일이 없는경우 새로 생성하고 있을경우 파일의 맨 마지막줄에 추가한다
'   이부분에 로그파일 경로를 수정해주세요

If Not objFSO.FolderExists("c:\infinisoft") Then
	objFSO.CreateFolder("c:\infinisoft")
End If

If objFSO.fileExists("c:\infinisoft\innopay_recv.log") Then
	Set f = objFSO.OpenTextFile("c:\infinisoft\innopay_recv.log",8,true)
Else
	Set f = objFSO.CreateTextFile("c:\infinisoft\innopay_recv.log",true)
End If

'**********************************************************************************	
Dim aDate(2), aTime(2)
aDate(0) = Year(Now)
aDate(1) = Right("0" & Month(Now), 2)
aDate(2) = Right("0" & Day(Now), 2)
aTime(0) = Right("0" & Hour(Now), 2)
aTime(1) = Right("0" & Minute(Now), 2)
aTime(2) = Right("0" & Second(Now), 2)
getNow = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)	   


f.WriteLine("*******************"+getNow+"******************************")
f.WriteLine("transSeq          : " + transSeq)
f.WriteLine("userId            : " + userId)
f.WriteLine("userName          : " + userName)
f.WriteLine("userPhoneNo       : " + userPhoneNo)
f.WriteLine("moid              : " + moid)
f.WriteLine("goodsName         : " + goodsName)
f.WriteLine("goodsAmt          : " + goodsAmt)
f.WriteLine("buyerName         : " + buyerName)
f.WriteLine("buyerPhoneNo      : " + buyerPhoneNo)
f.WriteLine("pgCode            : " + pgCode)
f.WriteLine("pgName            : " + pgName)
f.WriteLine("payMethod         : " + payMethod)
f.WriteLine("payMethodName     : " + payMethodName)
f.WriteLine("pgMid             : " + pgMid)
f.WriteLine("pgSid             : " + pgSid)
f.WriteLine("status            : " + status)
f.WriteLine("statusName        : " + statusName)
f.WriteLine("pgResultCode      : " + pgResultCode)
f.WriteLine("pgResultMsg       : " + pgResultMsg)
f.WriteLine("pgAppDate         : " + pgAppDate)
f.WriteLine("pgAppTime         : " + pgAppTime)
f.WriteLine("pgTid             : " + pgTid)
f.WriteLine("approvalAmt       : " + approvalAmt)
f.WriteLine("approvalNo        : " + approvalNo)
f.WriteLine("cardNo            : " + cardNo)
f.WriteLine("cardQuota         : " + cardQuota)
f.WriteLine("cardIssueCode     : " + cardIssueCode)
f.WriteLine("cardIssueName     : " + cardIssueName)
f.WriteLine("cardAcquireCode   : " + cardAcquireCode)
f.WriteLine("cardAcquireName   : " + cardAcquireName)

If payMethod = "01" Then
	f.WriteLine("cashReceiptType        : " + cashReceiptType)
	f.WriteLine("cashReceiptTypeName    : " + cashReceiptTypeName)
	f.WriteLine("cashReceiptSupplyAmt   : " + cashReceiptSupplyAmt)
	f.WriteLine("cashReceiptVat         : " + cashReceiptVat)
ElseIf payMethod = "02" OR payMethod = "03" Then
	f.WriteLine("cardNo         		: " + cardNo)
	f.WriteLine("cardQuota         		: " + cardQuota)
	f.WriteLine("cardIssueCode         	: " + cardIssueCode)
	f.WriteLine("cardIssueName         	: " + cardIssueName)
	f.WriteLine("cardAcquireCode        : " + cardAcquireCode)
	f.WriteLine("cardAcquireName        : " + cardAcquireName)
End If

If status = "85" Then
	f.WriteLine("cancelAmt         : " + cancelAmt)
	f.WriteLine("cancelMsg         : " + cancelMsg)
	f.WriteLine("cancelResultCode  : " + cancelResultCode)
	f.WriteLine("cancelResultMsg   : " + cancelResultMsg)
	f.WriteLine("cancelAppDate     : " + cancelAppDate)
	f.WriteLine("cancelAppTime     : " + cancelAppTime)
	f.WriteLine("cancelPgTid       : " + cancelPgTid)
	f.WriteLine("cancelApprovalAmt : " + cancelApprovalAmt)
	f.WriteLine("cancelApprovalNo  : " + cancelApprovalNo)
End If 

'상품 정보가 추가될 경우 (주석제거)
'f.WriteLine("goodsSize         : " + goodsSize)
'f.WriteLine("goodsCodeArray    : " + goodsCodeArray)
'f.WriteLine("goodsNameArray    : " + goodsNameArray)
'f.WriteLine("goodsAmtArray     : " + goodsAmtArray)
'f.WriteLine("goodsCntArray     : " + goodsCntArray)
'f.WriteLine("totalAmtArray     : " + totalAmtArray)

'배송지 정보가 추가될 경우 (주석제거)
'f.WriteLine("zoneCode     		: " + zoneCode)
'f.WriteLine("address     		: " + address)
'f.WriteLine("addressDetail     : " + addressDetail)
'f.WriteLine("recipientName     : " + recipientName)
'f.WriteLine("recipientPhoneNo  : " + recipientPhoneNo)
'f.WriteLine("comment     		: " + comment)

f.WriteLine("*************************************************")
	f.WriteLine("")
f.Close
	
'************************************************************************************

'위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "0000" 리턴되어야합니다.
'(주의) "0000"를 리턴하지 않으시면 인피니소프트 서버는 "0000"를 수신할때까지 계속 재전송을 시도합니다
'기타 다른 형태의 PRINT(response.write)는 하지 않으시기 바랍니다

dbResult = True 'DB 처리 성공여부 
If dbResult = True Then 
	response.write "0000" 
Else 
	reponse.write "9999"
End If

'데이터 등록 성공시 0000을 리턴해주세요
'데이터 등록 실패시 0000이 아닌것을 (예:9999) 리턴해주세요
	
'*************************************************************************************	

%>
