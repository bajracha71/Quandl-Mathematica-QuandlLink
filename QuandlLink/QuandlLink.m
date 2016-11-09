(* ::Package:: *)

(* Wolfram Language Package *)

(* Created by the Wolfram Workbench Jun 23, 2015 *)

BeginPackage["QuandlLink`"]
(* Exported symbols added here with SymbolName::usage *) 
QuandlFinancialData::usage = "QuandlFinancialData[name] returns the last known financial data of the entity specified by name "

Unprotect[QuandlFinancialData];

Options[QuandlFinancialData] = 
	{ 
		apiKey -> "", 
		sortOrder -> "", 
		startDate -> "",
		endDate -> "", 
		transform -> "", 
		collapse -> "",
		extra -> ""
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
		apiKey -> "", 
		sortOrder -> "", 
		startDate -> "" , 
		endDate -> "", 
		transform -> "", 
		collapse -> "",
		extra -> ""
	};

createParameter[val_, paramName_String] := 
	(* Return request parameter or empty if the option value is not specified *)
	Block[{}, 
		If[StringQ[val] && val === "", 
	    "", 
	    "&" <> paramName <> "=" <> If[ListQ[val], StringRiffle[val, ","], val]]]

createURL[name_String, opts: OptionsPattern[]]:=
	Block[
		{},
		(
			"https://www.quandl.com/api/v3/datasets/" <> 
 			name <> 
 			".csv?" <>
			 If[OptionValue[sortOrder] === "", "", "order=" <> OptionValue[sortOrder]] <>
			 createParameter[OptionValue[apiKey], "api_key"] <>
			 createParameter[OptionValue[startDate], "start_date"] <>
			 createParameter[OptionValue[endDate], "end_date"] <>
			 createParameter[OptionValue[transform], "transform"] <>
			 createParameter[OptionValue[collapse], "collapse"] <>
			 If[StringQ[OptionValue[extra]] && (OptionValue[extra] === ""),
				"",
			    Apply[StringJoin, Map[createParameter[OptionValue[extra][#], #]&, Keys[OptionValue[extra]]]]
			 ]
 		)
	]



(*Options[QuandlFinancialData] = Options[createURL]*)

QuandlFinancialData[name_String, opts : OptionsPattern[]] :=
	Block[
 		{
 			url = createURL[name, opts]
 		},
 		Import[url]
 	]
 	
End[]

EndPackage[]

SetAttributes[QuandlFinancialData, Protected]

