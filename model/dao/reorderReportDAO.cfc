<cffunction name="getReorderReportQuery" access="public" output="false" returntype="Query">
		<cfset rs = "" />
		
		<cfquery name="rs">
			SELECT
				SwSku.skuID,
				SwSku.skuCode,
				SwSku.calculatedQATS as skuQATS,
				SwProduct.calculatedQATS as productQATS,
				SwAttributeValue.attributeValue as ReOrderAmount,
				SwProduct.productID,
				SwProduct.productName,
				SwProductType.productTypeID,
				SwProductType.productTypeName
			FROM
			    SwSKu
				  LEFT JOIN
					swattributeValue on swSku.skuID = swattributeValue.skuID
				  INNER JOIN
					SwProduct on SwSku.productID = SwProduct.productID
				  INNER JOIN
					SwProductType on SwProduct.productTypeID = SwProductType.productTypeID
		</cfquery>
		
		<cfreturn rs />
	</cffunction>