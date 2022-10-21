<?php
/*******************************************************************************
 * FILE NAME : InnopayPgNoti_PHP.php
 * DATE : 2015.03.18
*******************************************************************************/

@extract($_GET);
@extract($_POST);
@extract($_SERVER);

/**********************************************************************************/
//�̺κп� �α����� ��θ� �������ּ���.	
$LogPath = "/home/httpd/htdocs/phpsample/log";
/**********************************************************************************/


$TEMP_IP = getenv("REMOTE_ADDR");
$PG_IP  = substr($TEMP_IP,0, 13);


/*******************************************************************************
 * ������           �ѱ۸�
 *--------------------------------------------------------------------------------
 ********************************************************************************
 * ����
 ********************************************************************************
 * transSeq			�ŷ���ȣ
 * userId			����ھ��̵�
 * userName			������̸�
 * userPhoneNo		������޴�����ȣ
 * moid				�ֹ���ȣ
 * goodsName		��ǰ��
 * goodsAmt			��ǰ�ݾ�
 * buyerName		�����ڸ�
 * buyerPhoneNo		�������޴�����ȣ
 * pgCode			PG�ڵ� ( 01:NICE / 02:KICC / 03:INFINISOFT / 04:KSNET / 05:KCP / 06:SMATRO )
 * pgName			PG��
 * payMethod		��������( 01:���ݰ��� / 02:�ſ�ī�� / 03:�ſ�ī��ARS )
 * payMethodName	�������ܸ�
 * pgMid			PG���̵�
 * pgSid			PG���񽺾��̵�
 * status			�ŷ����� ( 25:�����Ϸ� / 85:������� )
 * statusName		�ŷ����¸�
 * pgResultCode		PG����ڵ�
 * pgResultMsg		PG����޼���
 * pgAppDate		PG��������
 * pgAppTime		PG���νð�
 * pgTid			PG�ŷ���ȣ
 * approvalAmt		���αݾ�
 * approvalNo		���ι�ȣ
 ********************************************************************************
 * ���۰���(���ݿ�����)
 ********************************************************************************
 * cashReceiptType			�������� ( 1:�ҵ���� / 2:�������� )
 * cashReceiptTypeName		�������и�
 * cashReceiptSupplyAmt		���ް�
 * cashReceiptVat			�ΰ���
 ********************************************************************************
 * �ſ�ī�����
 ********************************************************************************
 * cardNo					ī���ȣ
 * cardQuota				�Һΰ���
 * cardIssueCode			�߱޻��ڵ� ( �޴������� )
 * cardIssueName			�߱޻��
 * cardAcquireCode			���Ի��ڵ� ( �޴������� )
 * cardAcquireName			���Ի��
 ********************************************************************************
 * �������
 ********************************************************************************
 * cancelAmt				��ҿ�û�ݾ�
 * cancelMsg				��ҿ�û�޼���
 * cancelResultCode			��Ұ���ڵ�
 * cancelResultMsg			��Ұ���޼���
 * cancelAppDate			��ҽ�������
 * cancelAppTime			��ҽ��νð�
 * cancelPgTid				PG�ŷ���ȣ
 * cancelApprovalAmt		���αݾ�
 * cancelApprovalNo			���ι�ȣ
*******************************************************************************/

	$transSeq      	= $transSeq;
	$userId        	= $userId;
	$userName      	= $userName;
	$userPhoneNo   	= $userPhoneNo;
	$moid          	= $moid;
	$goodsName     	= $goodsName;
	$goodsAmt      	= $goodsAmt;
	$buyerName     	= $buyerName;
	$buyerPhoneNo  	= $buyerPhoneNo;
	$pgCode        	= $pgCode;
	$pgName        	= $pgName;
	$payMethod     	= $payMethod;
	$payMethodName 	= $payMethodName;
	$pgMid         	= $pgMid;
	$pgSid         	= $pgSid;
	$status        	= $status;
	$statusName    	= $statusName;
	$pgResultCode  	= $pgResultCode;
	$pgResultMsg   	= $pgResultMsg;
	$pgAppDate     	= $pgAppDate;
	$pgAppTime     	= $pgAppTime;
	$pgTid         	= $pgTid;
	$approvalAmt   	= $approvalAmt;
	$approvalNo    	= $approvalNo;

	
	if($payMethod == '01'){
		//���ݰ���(���ݿ�����)
		$cashReceiptType		= $cashReceiptType;
		$cashReceiptTypeName	= $cashReceiptTypeName;
		$cashReceiptSupplyAmt	= $cashReceiptSupplyAmt;
		$cashReceiptVat			= $cashReceiptVat;

	}else if($payMethod == '02' || $payMethod == '03'){
		//�ſ�ī�� & �ſ�ī��ARS
		$cardNo				= $cardNo;
		$cardQuota			= $cardQuota;
		$cardIssueCode		= $cardIssueCode;
		$cardIssueName		= $cardIssueName;
		$cardAcquireCode	= $cardAcquireCode;
		$cardAcquireName	= $cardAcquireName;
	}


	if($status == '85'){
		//�������
		$cancelAmt			= $cancelAmt;
		$cancelMsg			= $cancelMsg;
		$cancelResultCode	= $cancelResultCode;
		$cancelResultMsg	= $cancelResultMsg;
		$cancelAppDate		= $cancelAppDate;
		$cancelAppTime		= $cancelAppTime;
		$cancelPgTid		= $cancelPgTid;
		$cancelApprovalAmt	= $cancelApprovalAmt;
		$cancelApprovalNo	= $cancelApprovalNo;
	}

	//��ǰ ������ �߰��� ��� (�ּ�����)
	//$goodsSize			= $goodsSize;
	//$goodsCodeArray		= $goodsCodeArray;
	//$goodsNameArray		= $goodsNameArray;
	//$goodsAmtArray		= $goodsAmtArray;
	//$goodsCntArray		= $goodsCntArray;
	//$totalAmtArray		= $totalAmtArray;

	//����� ������ �߰��� ��� (�ּ�����)
	//$zoneCode				= $zoneCode;
	//$address				= $address;
	//$addressDetail		= $addressDetail;
	//$recipientName		= $recipientName;
	//$recipientPhoneNo		= $recipientPhoneNo;
	//$comment				= $comment;


	$PageCall = date("Y-m-d [H:i:s]",time());
    $logfile = fopen( $LogPath . "/innopay_receive.log", "a+" );
    
    fwrite( $logfile,"************************************************\r\n");
	fwrite( $logfile,"PageCall time : ".$PageCall."\r\n");
	fwrite( $logfile,"transSeq      : ".$transSeq."\r\n");
	fwrite( $logfile,"userId        : ".$userId."\r\n");
	fwrite( $logfile,"userName      : ".$userName."\r\n");
	fwrite( $logfile,"userPhoneNo   : ".$userPhoneNo."\r\n");
	fwrite( $logfile,"moid          : ".$moid."\r\n");
	fwrite( $logfile,"goodsName     : ".$goodsName."\r\n");
	fwrite( $logfile,"goodsAmt      : ".$goodsAmt."\r\n");
	fwrite( $logfile,"buyerName     : ".$buyerName."\r\n");
	fwrite( $logfile,"buyerPhoneNo  : ".$buyerPhoneNo."\r\n");
	fwrite( $logfile,"pgCode        : ".$pgCode."\r\n");
	fwrite( $logfile,"pgName        : ".$pgName."\r\n");
	fwrite( $logfile,"payMethod     : ".$payMethod."\r\n");
	fwrite( $logfile,"payMethodName : ".$payMethodName."\r\n");
	fwrite( $logfile,"pgMid         : ".$pgMid."\r\n");
	fwrite( $logfile,"pgSid         : ".$pgSid."\r\n");
	fwrite( $logfile,"status        : ".$status."\r\n");
	fwrite( $logfile,"statusName    : ".$statusName."\r\n");
	fwrite( $logfile,"pgResultCode  : ".$pgResultCode."\r\n");
	fwrite( $logfile,"pgResultMsg   : ".$pgResultMsg."\r\n");
	fwrite( $logfile,"pgAppDate     : ".$pgAppDate."\r\n");
	fwrite( $logfile,"pgAppTime     : ".$pgAppTime."\r\n");
	fwrite( $logfile,"pgTid         : ".$pgTid."\r\n");
	fwrite( $logfile,"approvalAmt   : ".$approvalAmt."\r\n");
	fwrite( $logfile,"approvalNo    : ".$approvalNo."\r\n");

	if($payMethod == '01'){
		fwrite( $logfile,"cashReceiptType       : ".$cashReceiptType."\r\n");
		fwrite( $logfile,"cashReceiptTypeName   : ".$cashReceiptTypeName."\r\n");
		fwrite( $logfile,"cashReceiptSupplyAmt  : ".$cashReceiptSupplyAmt."\r\n");
		fwrite( $logfile,"cashReceiptVat        : ".$cashReceiptVat."\r\n");
	} else if($payMethod == '02' || $payMethod == '03'){
		fwrite( $logfile,"cardNo          : ".$cardNo."\r\n");
		fwrite( $logfile,"cardQuota       : ".$cardQuota."\r\n");
		fwrite( $logfile,"cardIssueCode   : ".$cardIssueCode."\r\n");
		fwrite( $logfile,"cardIssueName   : ".$cardIssueName."\r\n");
		fwrite( $logfile,"cardAcquireCode : ".$cardAcquireCode."\r\n");
		fwrite( $logfile,"cardAcquireName : ".$cardAcquireName."\r\n");
	}
	
	if($status == '85'){
		fwrite( $logfile,"cancelAmt         : ".$cancelAmt."\r\n");
		fwrite( $logfile,"cancelMsg         : ".$cancelMsg."\r\n");
		fwrite( $logfile,"cancelResultCode  : ".$cancelResultCode."\r\n");
		fwrite( $logfile,"cancelResultMsg   : ".$cancelResultMsg."\r\n");
		fwrite( $logfile,"cancelAppDate     : ".$cancelAppDate."\r\n");
		fwrite( $logfile,"cancelAppTime     : ".$cancelAppTime."\r\n");
		fwrite( $logfile,"cancelPgTid       : ".$cancelPgTid."\r\n");
		fwrite( $logfile,"cancelApprovalAmt : ".$cancelApprovalAmt."\r\n");
		fwrite( $logfile,"cancelApprovalNo  : ".$cancelApprovalNo."\r\n");
	
	}

	//��ǰ ������ �߰��� ��� (�ּ�����)
	//fwrite( $logfile,"goodsSize  		: ".$goodsSize."\r\n");
	//fwrite( $logfile,"goodsCodeArray  : ".$goodsCodeArray."\r\n");
	//fwrite( $logfile,"goodsNameArray  : ".$goodsNameArray."\r\n");
	//fwrite( $logfile,"goodsAmtArray  	: ".$goodsAmtArray."\r\n");
	//fwrite( $logfile,"goodsCntArray  	: ".$goodsCntArray."\r\n");
	//fwrite( $logfile,"totalAmtArray  	: ".$totalAmtArray."\r\n");

	//����� ������ �߰��� ��� (�ּ�����)
	//fwrite( $logfile,"zoneCode  		: ".$zoneCode."\r\n");
	//fwrite( $logfile,"address  		: ".$address."\r\n");
	//fwrite( $logfile,"addressDetail  	: ".$addressDetail."\r\n");
	//fwrite( $logfile,"recipientName  	: ".$recipientName."\r\n");
	//fwrite( $logfile,"recipientPhoneNo: ".$recipientPhoneNo."\r\n");
	//fwrite( $logfile,"comment  		: ".$comment."\r\n");
	
    fwrite( $logfile,"************************************************");
    fclose( $logfile );

//************************************************************************************

        //������ ���� �����ͺ��̽��� ��� ���������� ���� �����ÿ��� "0000"�� ���ǴϷ�
        //�����ϼž��մϴ�. �Ʒ� ���ǿ� �����ͺ��̽� ������ �޴� FLAG ������ ��������
        //(����) "0000"�� �������� �����ø� ���Ǵ� ���� ������ "0000"�� �����Ҷ����� ��� ������(�ִ�����Ƚ��)�� �õ��մϴ�
        //��Ÿ �ٸ� ������ PRINT( echo )�� ���� �����ñ� �ٶ��ϴ�

//      if (�����ͺ��̽� ��� ���� ���� ���Ǻ��� = true)
//      {

                echo "0000";                        // ����� ������������

//      }

//*************************************************************************************

?>















