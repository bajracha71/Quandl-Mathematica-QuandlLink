(* ::Package:: *)

(* Wolfram Language Package *)

(* Created by the Wolfram Workbench Jun 23, 2015 *)

BeginPackage["QuandlLink`"]
(* Exported symbols added here with SymbolName::usage *) 
QuandlFinancialData::usage = "QuandlFinancialData[name] returns the last known financial data of the entity specified by name "

Unprotect[QuandlFinancialData];

Options[QuandlFinancialData] = 
	{ 
		authCode -> "", 
		sortOrder -> "asc", 
		startDate -> lastTradingDate,
		endDate -> "", 
		transformation -> "", 
		collapse -> "",
		column -> ""
	};

Begin["`Private`"]
(* Implementation of the package *)

lastTradingDate = 
	StringJoin@Insert[
		Map[
			ToString, 
			DateValue[Yesterday, {"Year", "Month", "Day"}]
		],
		"-",
		{{2},{3}}
	];
	
Options[createURL] = 
	{ 
		authCode -> "", 
		sortOrder -> "asc", 
		startDate -> lastTradingDate , 
		endDate -> "", 
		transformation -> "", 
		collapse -> "",
		column -> ""
	};

createURL[name_String, opts: OptionsPattern[]]:=
	Block[
		{
			col
		},
		col /;IntegerQ[OptionValue[column]] = ToString[OptionValue[column] - 1];
	
		col /;((Head[OptionValue[column]] === List && Length[OptionValue@column]>= 2)|| Head[OptionValue[column]] === Span|| OptionValue[column] === "") = "";
		(
			"http://www.quandl.com/api/v3/datasets/" <> 
 			name <> 
 			".csv" <>
 			"?sort_order=" <> 
 			OptionValue[sortOrder]<>
 			"&auth_token" <>
 			OptionValue[authCode] <> 
 			"&trim_start=" <> 
 			OptionValue[startDate]<> 
 			"&trim_end=" <> 
			OptionValue[endDate]<>
 			"&transformation=" <> 
 			OptionValue[transformation] <> 
 			"&collapse" <> 
 			OptionValue[collapse]<>
 			"&column=" <> 
 			col
 		)
	]
			



(*Options[QuandlFinancialData] = Options[createURL]*)

QuandlFinancialData[name_String, opts : OptionsPattern[]] :=
	Block[
 		{
 			url = createURL[name, opts],
 			urlFetch,
 			stringsplit
 		}, 
 		urlFetch = URLFetch[url, "Method"->"GET"];
 		stringsplit = Fold[StringSplit, urlFetch, {"\n", ","}];
 		Map[
 			 Prepend[ToExpression@Rest@#, First@#]&,
 			 stringsplit 
 		]
 		
 	] /;(OptionValue[column] ==="")
 	

parseData[csvString_String, pos_]/;((ListQ[pos] && Length[pos] >= 2)|| IntegerQ[pos] ||Head[pos]===Span) :=
	Block[
		{
			stringSplit = Map[StringSplit[#, ","]&, StringSplit[csvString, "\n"]],
			fun,
			newStringSplit 
		},
		fun /; IntegerQ[pos] = Function[x, ToExpression[x[[pos]]]];
		fun /; (ListQ[pos] || Head[pos] === Span) = Function[x, ToExpression @ Rest @ x];
		newStringSplit = stringSplit[[All, If[IntegerQ[pos], {1, pos}, pos]]];
		Map[
			{First@#, fun[#]} &,
			newStringSplit 
   		]
 	 ]
  
 QuandlFinancialData[name_String, opts : OptionsPattern[]] :=
	Block[
 		{
 			url = createURL[name, opts],
 			urlFetch
  		}, 
 		urlFetch = URLFetch[url, "Method"->"GET"];
 		parseData[urlFetch, OptionValue[column]]
 		
 	] /;((ListQ[OptionValue[column]] && Length[OptionValue@column]>= 2)|| IntegerQ[OptionValue[column]] || Head[OptionValue[column]] === Span)
 
 

End[]

EndPackage[]

SetAttributes[QuandlFinancialData, Protected]

