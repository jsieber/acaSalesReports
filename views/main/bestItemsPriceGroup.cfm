<cfoutput>
<cfif not structKeyExists(rc, "bestItemsPriceGroupStartDate")>
	<!--- Default date values --->
	<cfset currentDate = dateFormat(now(), "m/d/yyyy") />
	<cfset currentCalendarDay = datePart("d", currentDate) />
	<cfset bestItemsPriceGroupEndDate = dateAdd("m", -1, currentDate) />
	<cfset bestItemsPriceGroupEndDate = dateAdd("d", -currentCalendarDay, currentDate) />
	<cfset daysInMonth = datePart("d", bestItemsPriceGroupEndDate) - 1 />
	<cfset bestItemsPriceGroupStartDate = dateAdd("d", -daysInMonth, bestItemsPriceGroupEndDate) />
	<p>Please select start and end dates for this report.</p>
	<form action="?s=1" name="bestItemsPriceGroupReportDates">
		<div class="form-group">
			<label for="bestItemsPriceGroupStartDate">Start Date</label>
			<input type="text" name="bestItemsPriceGroupStartDate" id="bestItemsPriceGroupStartDate" value="#dateFormat(bestItemsPriceGroupStartDate, "m/d/yyyy")#">
		</div>
		<div class="form-group">
			<label for="bestItemsPriceGroupEndDate">End Date</label>
			<input type="text" name="bestItemsPriceGroupEndDate" id="bestItemsPriceGroupEndDate" value="#dateFormat(bestItemsPriceGroupEndDate, "m/d/yyyy")#">
		</div>
		<input type="hidden" name="slatAction" value="aca_SalesReports:main.bestItemsPriceGroup" />
		<button type="submit" class="btn btn-primary">Submit</button>
	</form>
	
	<script>
  		$(function() {
    		$( "##bestItemsPriceGroupStartDate" ).datepicker();
    		$( "##bestItemsPriceGroupEndDate" ).datepicker();
  		});
  	</script>
<cfelse>
	<cfset i = 1 />
	<cfset cogsTotals = 0 />
	<cfset netTotals = 0 />
	<cfset avgGrossTotals = 0 />
	<cfset memberStatus = "" />
	<cfset memberTypeCogsTotals = 0 />
	<cfset memberTypeAvgGrossTotals = 0 />
	<cfset memberTypeNetTotals = 0 />
	<cfset allCogsTotals = 0 />
	<cfset allAvgGrossTotals = 0 />
	<cfset allNetTotals = 0 />
	<cfset prefix = "" />
	<cfset currentMemberType = "" />
	<cfif not structKeyExists(url, "print")>
		<p>
			<a href="#buildUrl('main.bestItemsPriceGroup&print&bestItemsPriceGroupStartDate=#rc.bestItemsPriceGroupStartDate#&bestItemsPriceGroupEndDate=#rc.bestItemsPriceGroupEndDate#')#">
				Print View
			</a>
		<p>
	</cfif>
	<cfif structKeyExists(url, "print")>
		<style>
			table {
				border-collapse: collapse;
			}
			table, th, tr, td  { 
				border: 1px solid LightGray;
			}
			thead {
				display: table-header-group;
			}
		</style>
		<p><strong>Best Items By Price Group Report</strong> printed on #DateFormat(Now(), "m/d/yyyy")#</p>
	</cfif>
	<table class="table table-condensed table-bordered table-striped" id="bestItemReport">	
		<thead>
		<tr>
			<th>Item No.</th>
			<th>Product Name - Option</th>
			<th>Sent</th>
			<th>Returned</th>
			<th>Sold</th>
			<th>Avg Cost</th>
			<th>Unit Cost</th>
			<th>COGS</th>
			<th>Returned Amount</th>
			<th>Gross</th>
			<th>Net</th>
		</tr>
		</thead>
		<tbody>				
		<cfloop query="#rc.bestItemsPriceGroupData#">
			<cfif mid(skuCode,1,2) NEQ prefix>
				<cfif i NEQ 1>
					<tr class="warning">
						<td colspan="7"><b>#prefix# - #memberStatus# totals:</b></td>
						<td><b>COGS</b></td>
						<td>&nbsp;</td>
						<td><b>Gross</b></td>
						<td><b>Net</b></td>	
					</tr>
					<tr class="warning">
						<td colspan="7">&nbsp;</td>
						<td><b>#DollarFormat(cogsTotals)#</b></td>
						<td>&nbsp;</td>
						<td><b>#dollarFormat(avgGrossTotals)#</b></td>
						<td><b>#dollarFormat(netTotals)#</b></td>	
					</tr>
					<cfset cogsTotals = 0 />
					<cfset avgGrossTotals = 0 />
					<cfset netTotals = 0 />
				</cfif>
				<cfif currentMemberType NEQ mem and i NEQ 1>
					<tr class="success">
						<td colspan="7"><b>#currentMemberType# totals:</b></td>
						<td><b>COGS</b></td>
						<td>&nbsp;</td>
						<td><b>Gross</b></td>
						<td><b>Net</b></td>	
					</tr>
					<tr class="success">
						<td colspan="7">&nbsp;</td>
						<td><b>#DollarFormat(memberTypeCogsTotals)#</b></td>
						<td>&nbsp;</td>
						<td><b>#dollarFormat(memberTypeAvgGrossTotals)#</b></td>
						<td><b>#dollarFormat(memberTypeNetTotals)#</b></td>	
					</tr>
					<cfset memberTypeCogsTotals = 0 />
					<cfset memberTypeAvgGrossTotals = 0 />
					<cfset memberTypeNetTotals = 0 />
				</cfif>
				<cfset prefix = mid(skuCode,1,2) />
				<cfset currentMemberType = mem />
				<tr>
					<td colspan="11"><b>#prefix# - #mem#</b></td>
				</tr>
			</cfif>
			
			<tr>
				<td nowrap>#skuCode# - <strong style="font-size:75%;">#mem#</strong></td>
				<td>#ProdName#</td>
				<td>#numSent#</td>
				<td>#NumRet#</td>
				<td>#NumSold#</td>
				<td>#dollarFormat(AvgCost)#</td>
				<td>#dollarFormat(UnitCost)#</td>
				<td>#dollarformat(COGS)#</td>
				<td>#dollarFormat(RetDollarAmt)#</td>
				<td>#dollarFormat(Gross)#</td>
				<td>#dollarFormat(Net)#</td>
			</tr>
			<cfset i++ />
			<cfset COGStotals += COGS />
			<cfset avgGrossTotals += Gross />
			<cfset NetTotals += Net />
			<cfset memberStatus = mem />
			<cfset memberTypeCogsTotals += COGS />
			<cfset memberTypeAvgGrossTotals += Gross />
			<cfset memberTypeNetTotals += Net />
			<cfset allCogsTotals += COGS />
			<cfset allAvgGrossTotals += Gross />
			<cfset allNetTotals += Net />
		</cfloop>
			<tr class="warning">
				<td colspan="7"><b>#prefix# - #memberStatus# totals:</b></td>
				<td><b>COGS</b></td>
				<td>&nbsp;</td>
				<td><b>Gross</b></td>
				<td><b>Net</b></td>	
			</tr>
			<tr class="warning">
				<td colspan="7">&nbsp;</td>
				<td><b>#DollarFormat(cogsTotals)#</b></td>
				<td>&nbsp;</td>
				<td><b>#dollarFormat(avgGrossTotals)#</b></td>
				<td><b>#dollarFormat(netTotals)#</b></td>	
			</tr>
			<tr class="success">
				<td colspan="7"><b>#memberStatus# totals:</b></td>
				<td><b>COGS</b></td>
				<td>&nbsp;</td>
				<td><b>Gross</b></td>
				<td><b>Net</b></td>	
			</tr>
			<tr class="success">
				<td colspan="7">&nbsp;</td>
				<td><b>#DollarFormat(memberTypeCogsTotals)#</b></td>
				<td>&nbsp;</td>
				<td><b>#dollarFormat(memberTypeAvgGrossTotals)#</b></td>
				<td><b>#dollarFormat(memberTypeNetTotals)#</b></td>	
			</tr>
			<tr class="info">
				<td colspan="7"><b>Totals:</b></td>
				<td><b>COGS</b></td>
				<td>&nbsp;</td>
				<td><b>Gross</b></td>
				<td><b>Net</b></td>	
			</tr>
			<tr class="info">
				<td colspan="7">&nbsp;</td>
				<td><b>#DollarFormat(allCogsTotals)#</b></td>
				<td>&nbsp;</td>
				<td><b>#dollarFormat(allAvgGrossTotals)#</b></td>
				<td><b>#dollarFormat(allNetTotals)#</b></td>	
			</tr>
		</tbody>
	</table>
</cfif>
</cfoutput>
