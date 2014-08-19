/*
 Adventure Cycling Association
 John Sieber 8/1/2014
 Integration for a Reorder Report
 

Notes:

*/
component extends="Slatwall.org.Hibachi.HibachiController" {
	 
	 public function getOpenPos (required struct rc, required string skuCode) {
	 	var result = "";
	 	var openPos = "";
	 	var openPosQuery = new query();
	 	openPosQuery.setDatasource('#application.configBean.getReadOnlyDatasource()#');
	 
	 	result = openPosQuery.execute(sql="SELECT
	 										SwSku.skuCode,
											SwStock.skuID,
											SwVendor.accountNumber,
											SwVendorOrder.vendorOrderID,
											SwStock.stockID,
											SwVendorOrder.vendorOrderNumber,
											SwVendorOrder.vendorOrderID,
											SwStockReceiverSum.stockID,
											SwStockReceiverSum.sumOfQuantity
										FROM SwSku
										LEFT JOIN
											SwStock on SwSku.skuID = SwStock.skuID
										INNER JOIN
											SwVendorOrderItem on SwStock.stockID = SwVendorOrderItem.stockID
										LEFT JOIN
											SwVendorOrder on SwVendorOrderItem.vendorOrderID = SwVendorOrder.vendorOrderID
										LEFT JOIN
											SwVendor on SwVendorOrder.vendorID = SwVendor.vendorID
										LEFT JOIN
											SwStockReceiverSum on SwStock.stockID = SwStockReceiverSum.stockID
										WHERE SwSku.skuCode = '#arguments.skuCode#'");
										rc.thePos = result.getResult();
	 
	 }
	 
	 public function reorderReport (required struct rc) {
	 	// writeDump(var="I'm here" abort=true);
		var result = "";	
		var theData = "";
		var reOrderData = new query();
		reOrderData.setDatasource('#application.configBean.getReadOnlyDatasource()#');
								
				result =  reOrderData.execute(sql="SELECT
											SwSku.skuID,
											SwSku.skuCode,
											SwOption.optionName,
											SwSku.calculatedQATS as skuQATS,
											SwProduct.calculatedQATS as productQATS,
											SwAttributeValue.attributeValue as ReOrderAmount,
											SwProduct.productID,
											SwProduct.productName,
											SwProductType.productTypeID,
											SwProductType.productTypeName
											FROM
												SwSku
											LEFT JOIN
												SwattributeValue on SwSku.skuID = SwattributeValue.skuID
											LEFT JOIN
												SwSkuOption on SwSku.skuID = SwSkuOption.skuID
											LEFT JOIN
												SwOption on SwSkuOption.optionID = SwOption.optionID
											INNER JOIN
												SwProduct on SwSku.productID = SwProduct.productID
											INNER JOIN
												SwProductType on SwProduct.productTypeID = SwProductType.productTypeID			
											WHERE SwAttributeValue.attributeValue >= SwSku.calculatedQATS AND SwAttributeValue.attributeValue > 0
											ORDER BY SwSku.skuCode;");
										rc.theData = result.getResult();
											
		
		//writeDump(var="#rc.theData#", abort=true);
		
		 
		
		 // rc.result = theData;
		 // return rc.result; 
		}
		
		private function vendorPOData (required string vendorId) {
			var result = "";	
			var vendorPoList = "";
			var vendorPoData = new query();
			vendorPoData.setDatasource('#application.configBean.getReadOnlyDatasource()#');
			vendorPoData.addParam(name="vendorId",value="#arguments.vendorId#",cfsqltype="cf_sql_varchar");	
				result =  vendorPoData.execute(sql="SELECT	SwStock.skuID,
														SwVendor.accountNumber,
														SwVendorOrder.vendorOrderID,
														SwVendorOrder.vendorOrderStatusTypeID,
														SwVendorOrder.createdDateTime,
														SwStock.stockID,
														SwVendorOrder.vendorOrderNumber,
														SwVendorOrder.vendorOrderID,
														SwVendorOrderItem.quantity,
														SwStockReceiverSum.stockID,
														SwStockReceiverSum.sumOfQuantity,
														sum((SwvendorOrderItem.quantity * SwvendorOrderItem.cost)) AS 'orderCost',
														sum(SwVendorOrderItem.quantity) as totalOrderQuantity,
														sum(SwStockReceiverSum.sumOfQuantity) as totalOrderQuantityReceived
													FROM SwVendorOrder
													LEFT JOIN
														SwVendorOrderItem on SwVendorOrder.vendorOrderID = SwVendorOrderItem.vendorOrderID
													LEFT JOIN
														SwVendor on SwVendorOrder.vendorID = SwVendor.vendorID
													INNER JOIN
														SwStock on SwVendorOrderItem.stockID = SwStock.stockID
													LEFT JOIN
														SwStockReceiverSum on SwStock.stockID = SwStockReceiverSum.stockID
													WHERE ( Swvendor.vendorId = :vendorId )
													GROUP BY SwvendorOrder.vendorOrderID	
													ORDER BY SwVendorOrder.createdDateTime");
				rc.vendorPoList = result.getResult();
				// writeDump(var="#rc.vendorPoList#" abort=true);
				return rc.vendorPoList;
		
		}
		
		public function vendorPOReport (required struct rc) {
			if (!structKeyExists(rc, "submit")) {
			// return listing for form
			var result = "";	
			var vendorList = "";
			var vendorData = new query();
			vendorData.setDatasource('#application.configBean.getReadOnlyDatasource()#');
				
				result =  vendorData.execute(sql="SELECT
											Swvendor.vendorID,
											Swvendor.vendorName,
											Swvendor.accountNumber
											FROM
												Swvendor			
											ORDER BY Swvendor.vendorName;");
				rc.vendorList = result.getResult();
			}else{
				// return data for report
				var vendorPoList = "";
				rc.vendorPoList = vendorPOData(rc.vendorSelect);
				//writeDump(var="#rc.vendorPoList#" abort=true);
			
			
			
			
			}
		
		
		}
		
		// getFW().redirect(action="aca_ReorderReport:main.getreorderData");
	}	