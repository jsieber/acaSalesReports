<cfoutput>
<!--- <cfdump var="#isQuery(rc.theData)#" top=2 abort=true> --->
<cfscript>
public function getOpenPos (required string skuCode) {
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
										local.thePos = result.getResult();
										//writedump(var="#local.thePos#" abort=true);
										return local.thePos; 
	 }
</cfscript>

<cfif structKeyExists(rc, "theData") and rc.theData.recordcount>
	<!--- <cfdump var="#rc.result#" abort=true> --->
	<table class="table table-condensed table-bordered table-striped">
		<tr>
			<th colspan="7" align="right">Reorder Items</th>
		</tr>
		<tr>
			<td>Item No.</td>
			<td>Vendor No.</td>
			<td>Item Name</td>
			<td>Amount Back Ordered</td>
			<td>Amount On Hand</td>
			<td>Reorder Limit</td>
			<td>Open PO</td>
		</tr>
	<cfset prefix = "">
	
	<cfloop query="rc.theData">
		<cfset thePos = getOpenPos(skuCode) />
		<!--- <cfdump var="#thePos#" top=2 abort=true> --->
		<cfif skuQATS LT 0>
			<cfset theClass = "warning" />
		<cfelse>
			<cfset theClass = "" />
		</cfif>
		<cfif mid(skuCode,1,2) NEQ prefix>	
			<cfset prefix = mid(skuCode,1,2)>
			<tr>
				<th colspan="7"><B>#prefix#</B></th>
			</tr>
		</cfif>
		<tr class="#theClass#">
			<td>#skuCode#</td>
			<td>#thePos.AccountNumber#</td>
			<td>#productName# <cfif optionName neq "">- #optionName#</cfif></td>
			<td><cfif skuQATS LT 0>#skuQATS#</cfif></td>
			<td><cfif skuQATS GTE 0>#skuQATS#<cfelse>0</cfif></td>
			<td>#ReOrderAmount#</td>
			<td>
				<cfif thePos.vendorOrderID neq ""><a href="/Slatwall/?slatAction=entity.detailvendororder&vendorOrderID=#thePos.vendorOrderId#">#thePos.vendorOrderNumber#</a></cfif>
			</td>
		</tr>
	</cfloop>
	</table> 
<cfelse>
	<p>Something has went wrong...</p>
</cfif>
</cfoutput>