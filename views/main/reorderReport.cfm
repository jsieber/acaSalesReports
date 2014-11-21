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
											SwVendor.vendorName,
											SwVendorOrder.vendorOrderID,
											SwStock.stockID,
											SwVendorOrder.vendorOrderNumber,
											SwVendorOrderItem.Quantity,
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
											SwStockReceiverSum on SwVendorOrderItem.vendorOrderItemID = SwStockReceiverSum.vendorOrderItemID
										WHERE SwSku.skuCode = '#arguments.skuCode#' and (SwStockReceiverSum.sumOfQuantity < SwVendorOrderItem.Quantity or SwStockReceiverSum.sumOfQuantity is null)");
										local.thePos = result.getResult();
										//writedump(var="#local.thePos#" abort=true);
										return local.thePos; 
	 }
</cfscript>

<cfif structKeyExists(rc, "theData") and rc.theData.recordcount>
	<!--- <cfdump var="#rc.result#" abort=true> --->
	<cfif not structKeyExists(url, "print")>
		<p><a href="#buildUrl('main.reorderReport&print')#">Print View</a><p>
	
		<table class="table table-condensed table-bordered table-striped">
			<tr class="warning">
				<td>Records in yellow indicated that the Quantity Availabe to Sell is currently less than 0!</td>
			</tr>
		</table>
	</cfif>
	
	<table class="table table-condensed table-bordered table-striped tablesorter" id="reorderReport">
		<thead>
		<!--- <tr>
			<th colspan="7" align="right">Reorder Items</th>
		</tr> --->
		<tr>
			<th>Item No.</th>
			<th>Vendor Sku</th>
			<th>Item Name - Size(Option)</th>
			<th>Brand</th>
			<th>Vendor</th>
			<th>Unit Cost</th>
			<th>Amount On Hand</th>
			<th>Reorder Limit</th>
			<th>Open PO</th>
		</tr>
		</thead>
	<cfset prefix = "">
	<tbody>
	<cfloop query="rc.theData">
		<cfset thePos = getOpenPos(skuCode) />
		<!--- <cfdump var="#thePos#" top=2 abort=true> --->
		<cfif skuQATS LT 0>
			<cfset theClass = "warning" />
		<cfelse>
			<cfset theClass = "" />
		</cfif>
		
		<!--- <cfif mid(skuCode,1,2) NEQ prefix>	
			<cfset prefix = mid(skuCode,1,2)>
		
		<tr>
			<th colspan="7"><B>#prefix#</B></th>
		</tr>
		</cfif>  --->
		<tr class="#theClass#">
			<td>#skuCode#</td>
			<td>#vendorSku#</td>
			<td>#productName# <cfif optionName neq "">- #optionName#</cfif></td>
			<td>#brandName#</td>
			<td>#vendorName#</td>
			<td>#dollarFormat(unitCost)#</td>
			<td><cfif skuQATS GTE 0>#skuQATS#<cfelse>0</cfif></td>
			<td>#ReOrderAmount#</td>
			<td>
				<cfif thePos.vendorOrderID neq ""><a href="/Slatwall/?slatAction=entity.detailvendororder&vendorOrderID=#thePos.vendorOrderId#">#thePos.vendorOrderNumber#</a><cfif thePos.vendorName neq "">(#thePos.vendorName#)</cfif></cfif>
			</td>
		</tr>
		
	</cfloop>
	</tbody>
	</table> 
	
	<script type="text/javascript">
		$(document).ready(function() { 
       		 $("##reorderReport").tablesorter(); 
		  } 
		); 
	</script>
<cfelse>
	<p>Something has went wrong...</p>
</cfif>
</cfoutput>