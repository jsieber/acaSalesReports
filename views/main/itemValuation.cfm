<cfoutput>
<!--- <cfif not structKeyExists(rc, "submit")>
		
	<form name="rc.itemValuation" action="?s=1">
		<fieldset>
			<legend>Item Valuation Report<legend>
			<label for="startNumber">Start Number</label>
			<input type="text" name="startNumber" value="">
			<label for="endNumber">End Number</label>
			<input type="text" name="endNumber" value="">
			<label></label>
			<input type="hidden" name="slatAction" value="aca_SalesReports:main.itemValuation" />
			<button type="submit" name="submit" class="btn btn-primary">Submit</button>
		</fieldset>
	</form>

<cfelse> --->
	<cfif rc.itemValuationData.recordcount>
		<!--- <cfdump var="#rc.itemValuationData#"> --->
		<cfset UNItotal = 0>
		<cfset EXPtotal = 0>
		<cfset GrandTotal = 0>
		<cfset i = 1>
		
		<table class="table table-condensed table-bordered table-striped">
			<tr>
				<th colspan="6" align="right">Reorder Items</th>
			</tr>
			<tr>
				<td>Item No.</td>
				<td>Item Name</td>
				<td>Vendor No. and Name</td>
				<td>Amount On Hand</td>
				<td>Unit Cost</td>
				<td>Extended Cost</td>
			</tr>
			<cfset prefix = "">
			<cfloop query="rc.itemValuationData">
				<cfif mid(skuCode,1,2) NEQ prefix>
					<cfif i NEQ 1>
						<TR class="TOTALROW">
							<td colspan="3">&nbsp;</td>
							<td>#prefix# totals:</td>
							<td align="right">#DollarFormat(UNItotal)#</td>
							<td align="right">#DollarFormat(EXPtotal)#</td>
								<cfset UNItotal = 0>
								<cfset EXPtotal = 0>
						</tr>
					</cfif>
					<cfset prefix = mid(skuCode,1,2)>
					<tr>
						<Td colspan="6"><B>#prefix#</B></td>
					</tr>
				</cfif>
					<tr>	
						<td>#skuCode#</td>
						<td>#productName# - #optionName#</td>
						<td><!--- Can't link to vendor unless vendor orders exist and it might change ---></td>
						<td>#skuQATS#</td>
						<td>#dollarFormat(unitCost)#</td>
						<td>#dollarFormat(extendedCost)#</td>	
					</tr>
				<cfset UNItotal = UNItotal + unitCost>
				<cfset EXPtotal = EXPtotal + extendedCost>
				<cfset GrandTotal = GrandTotal + extendedCost>
				<cfset i = i +1>
			</cfloop>
			<tr class="TOTALROW">
				<td colspan="3">&nbsp;</td>
				<td>#prefix# totals:</td>
				<td align="right">#DollarFormat(UNItotal)#</td>
				<td align="right">#DollarFormat(EXPtotal)#</td>
					<cfset UNItotal = 0>
					<cfset EXPtotal = 0>
			</tr>
			<tr bgcolor="##000000" class="TINYTEXT">
				<td colspan="6" height="1">&nbsp;</td>
			</tr>
			<tr class="TOTALROW">
				<td colspan="5" align="right">Total Extended Costs:</td>
				<td align="right">#DollarFormat(grandTotal)#</td>
			</tr>
		
	<cfelse>
		<p class="alert alert-danger">No records exist for the criteria defined!</p>
	</cfif>
<!--- </cfif> --->
</cfoutput>