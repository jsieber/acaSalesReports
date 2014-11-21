/*
 Adventure Cycling Association
 John Sieber 8/1/2014
 Integration for ACA Sales Reports
 

Notes:

*/
component extends="Slatwall.org.Hibachi.HibachiController" {
	 
	 public function bestItems (){
	 	if(structKeyExists(rc, "bestItemsStartDate") && structKeyExists(rc, "bestItemsEndDate")){
	 		rc.bestItemsData = bestItemsQuery(rc, rc.bestItemsStartDate, rc.bestItemsEndDate);
	 		//writeDump(var="#rc.bestItemsData#", abort=true);
			return rc.bestItemsData;
	 	}
	 }
	 
	 public query function bestItemsQuery (required struct rc, required date startDate, required date endDate) {
	 	
	 	var result = "";
	 	var bestItemsQuery = new query();
	 	bestItemsQuery.setDatasource('#application.configBean.getReadOnlyDatasource()#');
	 	bestItemsQuery.addParam(name="startDate",value="#arguments.startDate#",cfsqltype="cf_sql_date");
		bestItemsQuery.addParam(name="endDate",value="#arguments.endDate#",cfsqltype="cf_sql_date");
	 	result = bestItemsQuery.execute(sql="select Mem,Left(skuCode,2) AS SalesGroup, swsku.skuCode, Concat_WS('-',productName, OptionName) AS ProdName, Sum(quantity) AS NumSent, 
												If(IsNull(NumRet),0,NumRet) AS NumRet,Sum(quantity)-If(IsNull(NumRet),0,NumRet) AS NumSold, 
												Round((Sum(quantity*sworderitem.Price))/Sum(quantity),2) AS AvgCost, attributevalue AS UnitCost, Sum(quantity*attributevalue) AS COGS, 
												If(IsNull(Refunded),0,Refunded) AS RetDollarAmt, Sum(quantity*sworderitem.Price) AS Gross, 
												(Sum(quantity*sworderitem.Price))-(Sum(quantity*attributevalue)) AS Net 
												from sworder 
												INNER JOIN sworderitem ON sworder.orderID = sworderitem.orderID 
												INNER JOIN swsku ON sworderitem.skuID = swsku.skuID 
												INNER JOIN swattributevalue ON sworderitem.skuID = swattributevalue.skuID 
												INNER JOIN swproduct ON swsku.productID = swproduct.productID 
												
												LEFT JOIN (select skuID, Sum(quantity) AS NumRet, Sum((-quantity)*sworderitem.Price) AS Refunded 
												from sworder 
												INNER JOIN sworderitem ON sworder.orderID = sworderitem.orderID 
												WHERE orderCloseDateTime BETWEEN :startDate AND :endDate 
												AND orderstatustypeID = '444df2b8b98441f8e8fc6b5b4266548c' 
												AND orderTypeID = '444df2dd05a67eab0777ba14bef0aab1' 
												Group by skuID) AS Returneditems ON sworderitem.skuID = returneditems.skuID 
												
												LEFT JOIN (SELECT skuID, GROUP_CONCAT(DISTINCT SwOption.optionName SEPARATOR ' - ') as OptionName 
												From swoption 
												INNER JOIN swskuoption ON swoption.optionID = swskuoption.optionID 
												Group by skuID) AS OptionList 
												ON sworderitem.skuID = OptionList.skuID 
												
												INNER JOIN (SELECT orderID,If(ExpirationDate > (orderCloseDateTime + interval -(2) year), 'Member', 'NonMember') AS Mem 
												from sworder 
												INNER JOIN swaccount ON sworder.accountID = swaccount.accountID 
												LEFT JOIN adventurecycling_org.rpeople ON swaccount.remotecustomerID = rpeople.XTR_ID 
												WHERE orderCloseDateTime BETWEEN :startDate AND :endDate) AS MemNonMem 
												ON sworder.orderID = MemNonMem.orderID 
												
												WHERE orderCloseDateTime BETWEEN :startDate AND :endDate 
												AND attributeID = '8a4b0819480b3df801481f0b48462fd4' 
												AND orderstatustypeID = '444df2b8b98441f8e8fc6b5b4266548c' 
												AND orderTypeID = '444df2df9f923d6c6fd0942a466e84cc' 
												Group by Mem, skuCode 
												ORDER BY Mem, skuCode");
												
		rc.bestItems = result.getResult();
		//writeDump(var="#rc.bestItems#" abort=true);
	 	return rc.bestItems;										
	 	
	 
	 }
	 
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
	 
	 public function itemValuation (required struct rc) {
	 	
	 	// if (structKeyExists(rc, "submit")){
	 		// writeDump(var="#rc#", abort=true, top=1);
		 	var result = "";
		 	var itemValuationQuery = new query();
		 	itemValuationQuery.setDatasource('#application.configBean.getReadOnlyDatasource()#');
		 	// itemValuationQuery.addParam(name="startNumber",value="#rc.startNumber#",cfsqltype="cf_sql_varchar");
		 	// itemValuationQuery.addParam(name="endNumber",value="#rc.endNumber#",cfsqltype="cf_sql_varchar");
		 		result = itemValuationQuery.execute(sql="SELECT SwSku.skuID,
															   SwSku.skuCode,
															   SwSku.calculatedQATS as skuQATS,
															   SwProduct.productID,
															   SwProduct.productName,
															   GROUP_CONCAT(DISTINCT SwOption.optionName SEPARATOR ' - ') as OptionName,
															   SwProductType.productTypeID,
															   SwProductType.productTypeName,
															   SwAttributeValue.attributeValue as unitCost,
															   (SwAttributeValue.attributeValue * SwSku.calculatedQATS) as extendedCost
														FROM swsku
														INNER JOIN
															SwProduct on SwSku.productID = SwProduct.productID
														INNER JOIN
															SwProductType on SwProduct.productTypeID = SwProductType.productTypeID
														LEFT JOIN
															SwSkuOption on SwSku.skuID = SwSkuOption.skuID
														LEFT JOIN
															SwOption on SwSkuOption.optionID = SwOption.optionID
														LEFT JOIN
															SwattributeValue on SwSku.skuID = SwattributeValue.skuID
														LEFT JOIN 
															Swattribute on SwattributeValue.attributeID = Swattribute.attributeID
														WHERE Swattribute.attributecode = 'unitCost' and Swsku.activeFlag = 1 and SwProduct.activeFlag = 1 and SwProduct.publishedFlag = 1 and SwSku.calculatedQATS > 0					
														GROUP BY swSku.skuid
														ORDER BY SwSku.skuCode;");
		 		rc.itemValuationData = result.getResult();
		 
		 
		 
		//}
	 }
	 
	 public function reorderReport (required struct rc) {
		var result = "";	
		var theData = "";
		var reOrderData = new query();
		reOrderData.setDatasource('#application.configBean.getReadOnlyDatasource()#');
								
				result =  reOrderData.execute(sql="SELECT
													SwSku.skuID,
													SwSku.skuCode,
													GROUP_CONCAT(DISTINCT SwOption.optionName SEPARATOR ' - ') as OptionName,
													SwSku.calculatedQATS as skuQATS,
													SwProduct.calculatedQATS as productQATS,
													SwBrand.brandName,
													SwattributeValueReOrderAmount.attributeValue as ReOrderAmount,
													SwattributeValueVendorSku.attributeValue as VendorSku,
													SwattributeValueUnitCost.attributeValue as UnitCost,
													SwProduct.productID,
													SwProduct.productName,
													SwProductType.productTypeID,
													SwProductType.productTypeName,
													Swvendor.vendorName
													FROM
														SwSku
													LEFT JOIN
														SwattributeValue as SwattributeValueReOrderAmount on SwSku.skuID = SwattributeValueReOrderAmount.skuID AND SwattributeValueReOrderAmount.attributeID = '8a4b081947884ff301478919b1f805a3'
													LEFT JOIN
														SwattributeValue as SwattributeValueVendorSku on SwSku.skuID = SwattributeValueVendorSku.skuID AND SwattributeValueVendorSku.attributeID = '8a4b081948b631770148c8ed9661170c'
													LEFT JOIN
														SwattributeValue as SwattributeValueUnitCost on SwSku.skuID = SwattributeValueUnitCost.skuID AND SwattributeValueUnitCost.attributeID = '8a4b0819480b3df801481f0b48462fd4'
													LEFT JOIN
														SwSkuOption on SwSku.skuID = SwSkuOption.skuID
													LEFT JOIN
														SwOption on SwSkuOption.optionID = SwOption.optionID
													INNER JOIN
														SwProduct on SwSku.productID = SwProduct.productID
													LEFT JOIN
														Swvendorproduct on SwProduct.productID = Swvendorproduct.productID
													LEFT JOIN
														Swvendor on Swvendorproduct.vendorID = Swvendor.vendorID
													INNER JOIN
														SwProductType on SwProduct.productTypeID = SwProductType.productTypeID	
													INNER JOIN 
														SwBrand on SwProduct.brandID = SwBrand.brandID
													WHERE SwattributeValueReOrderAmount.attributeValue >= SwSku.calculatedQATS AND SwattributeValueReOrderAmount.attributeValue >= 0
													GROUP BY swSku.skuid
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