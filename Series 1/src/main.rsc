module main

import IO;
import Set;
import List;
import Type;
import String;
import Map;

import Ranking;
import Volume;
import Helpers;
import Complexity;
import Duplication;
import UnitInterfacing;
import UnitTesting;
import WMC;

import util::Math;
import util::Benchmark;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

int getTestLOC(list[loc] testFiles) {
	int testLOC = 0;
	for (class <- testFiles) {
		testLOC += countLinesOfCode(class);
	}
	return testLOC;
}

list[loc] getTestFiles(M3 model) {
	return [ f  | f <- files(model), startsWith(f.file, "Test")];
}

tuple[int, int, int] getMethodStats(Declaration method){
	int methodLines = countLinesOfCode(method.src);
	int methodComplexity = cyclomaticComplexity(method);
	int methodParameters = unitInterfacing(method);
	
	return <methodLines, methodComplexity, methodParameters>;
}

tuple[int, int, int, int] addStats (tuple[int, int, int, int] first, tuple[int, int, int, int] second){

	tuple[int, int, int, int] result = <0,0,0,0>;

	result[0] = first[0] + second[0];
	result[1] = first[1] + second[1];
	result[2] = first[2] + second[2];
	result[3] = first[3] + second[3];
	
	return result;
}

tuple [int, int, int, int] catagorizeComplexity(int cc, int lines){

	tuple[int, int, int, int] result = <0,0,0,0>;

	if (cc < 11) {result[0] += lines;}
	else if (cc < 21) {result[1] += lines;}
	else if (cc < 51) {result[2] += lines;}
	else {result[3] += lines;}
	
	return result;
}

tuple [int, int, int, int] catagorizeUnitSize(int lines){

	tuple[int, int, int, int] result = <0,0,0,0>;

	if (lines < 30) {result[0] += lines;}
	else if (lines < 44) {result[1] += lines;}
	else if (lines < 74) {result[2] += lines;}
	else {result[3] += lines;}
	
	return result;
	
}

tuple [int, int, int, int] catagorizeUnitInterfacing(int parameters, int lines){

	tuple[int, int, int, int] result = <0,0,0,0>;

	if (parameters < 2) {result[0] += lines;}
	else if (parameters < 3) {result[1] += lines;}
	else if (parameters < 4) {result[2] += lines;}
	else {result[3] += lines;}
	
	return result;
}

tuple[real, real, real, real] metricPercentages (tuple[int simple, int moderate, int complex, int unstable] metric, int lines){
	tuple[real simple, real moderate, real complex, real unstable] percentages = <metric.simple/toReal(lines)*100,
																				 metric.moderate/toReal(lines)*100,
																				 metric.complex/toReal(lines)*100,
																				 metric.unstable/toReal(lines)*100>;
																				
	return percentages;
}

str metricData(tuple [real simple, real moderate, real complex, real unstable] metric){
	return (
	"	Low:<metric.simple>%
	 Moderate:<metric.moderate>%
	 Complex:<metric.complex>%
	 Unstable:<metric.unstable>%
	");
}

tuple [int, int, int, int] normalize(tuple[int, int, int, int] catagories, int methodLines, int totalLines){
	tuple[int, int, int, int] result = <0,0,0,0>;
	int linesOutsideMethods = totalLines - methodLines;

	for (i <- [0..4]){
		result[i] = catagories[i] + round(linesOutsideMethods * catagories[i] / toReal(methodLines));
	}
	
	return result;
}

map[loc classSrc, int totalCC] calculateWMC (set[Declaration] classes) {

	map[loc classSrc, int totalCC] classCcMap = ();

	for (class <- classes){
		int sumComplexity = 0;
	
		visit(class){
			case m:\method(Type _, str _, list[Declaration] _, list[Expression] _, Statement impl): sumComplexity += cyclomaticComplexity(m);
	    	case m:\method(Type _, str _, list[Declaration] _, list[Expression] _): sumComplexity += cyclomaticComplexity(m);
	     	case m:\constructor(str _, list[Declaration] _, list[Expression] _, Statement ): sumComplexity += cyclomaticComplexity(m);
	     	case m:\initializer(Statement impl): sumComplexity += cyclomaticComplexity(m);
		}
		
		classCcMap[class.src] = sumComplexity;
	}
	
	return classCcMap;
}

void main(loc projectLocation) {
	M3 model = createM3FromEclipseProject(projectLocation);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
	
	println("
	
	========= VOLUME ==========
	
	");
	
	int totalLinesOfCode = countProjectLinesOfCode(model);
	str volumeRank = rankVolume(totalLinesOfCode);
	println("Lines of code: <totalLinesOfCode> rank: <volumeRank>");
	
	map[loc, tuple[int, int, int]] unitStats = ();
	
	tuple[int simple, int moderate, int complex, int unstable] complexityPerUnit = <0, 0, 0, 0>;
	tuple[int simple, int moderate, int complex, int unstable] sizePerUnit = <0, 0, 0, 0>;
	tuple[int simple, int moderate, int complex, int unstable] interfacingPerUnit = <0, 0, 0, 0>;
	
	int totalComplexity = 0;
	int methodLines = 0;
	
	for (method <- projectMethods) {

		tuple[int lines, int complexity, int parameters] stats = getMethodStats(method);
		
		complexityPerUnit = addStats(complexityPerUnit, catagorizeComplexity(stats.complexity, stats.lines));
		sizePerUnit = addStats(sizePerUnit, catagorizeUnitSize(stats.lines));
		interfacingPerUnit = addStats(interfacingPerUnit, catagorizeUnitInterfacing(stats.parameters, stats.lines));
		
		methodLines += stats.lines;
		unitStats[method.src] = stats;
				
		totalComplexity += stats.complexity;
	}
	
	list[loc] testFiles = getTestFiles(model);
	int testLOC = getTestLOC(testFiles);
	int assertCount = size(getAssertCount(asts));
	//
	// should add up to 100% (normalization, take other lines of code and divide them over methods)
	//tuple[real simple, real moderate, real complex, real unstable] percentagesComplexity = metricPercentages(complexityPerUnit, totalLinesOfCode);
	//tuple[real simple, real moderate, real complex, real unstable] percentagesVolume = metricPercentages(sizePerUnit, totalLinesOfCode);
	//tuple[real simple, real moderate, real complex, real unstable] percentagesInterfacing = metricPercentages(interfacingPerUnit, totalLinesOfCode);
	//
	//
	//
	//// used older versions, for calibration
	//
	tuple[real simple, real moderate, real complex, real unstable] percentagesComplexity = metricPercentages(complexityPerUnit, methodLines);
	tuple[real simple, real moderate, real complex, real unstable] percentagesVolume = metricPercentages(sizePerUnit, methodLines);
	tuple[real simple, real moderate, real complex, real unstable] percentagesInterfacing = metricPercentages(interfacingPerUnit, methodLines);
	//					
	println("
	
	========= COMPLEXITY ==========
	
	");					
																					
	str complexityRank = rankComplexity(percentagesComplexity);									
	println(metricData(percentagesComplexity));
	println("Complexity rank: <complexityRank>");
	
	println("
	
	========= UNIT SIZE ==========
	
	");
	
	str unitVolumeRank = rankUnitSize(percentagesVolume);
	println(metricData(percentagesVolume));
	println("Unit Size rank: <unitVolumeRank>");
	
	println("
	
	========= INTERFACING ==========
	
	");
	
	str interfacingRank = rankInterfacing(percentagesInterfacing);
	println(metricData(percentagesInterfacing));
	println("Interfacing rank: <interfacingRank>");
	
	println("
	
	========= DUPLICATION ==========
	
	");
	
	int dupLines = codeDuplication(model);
	real dupLinesPercentage = dupLines / toReal(totalLinesOfCode) * 100;
	
	str duplicationRank = rankDuplication(dupLinesPercentage);
	println("Duplication: <dupLines> percentage: <dupLinesPercentage>% rank: <duplicationRank>");
	
	println("
	
	========= UNIT TESTING ==========
	
	");
	
		
	real assertionDensity = (assertCount / toReal(testLOC) * 100);
	real assertionMcCabe = (assertCount / toReal(totalComplexity));
	str densityRank = rankAssertionDensity(assertionDensity);
	str mcCabeRank = rankAssertionMcCabe(assertionMcCabe);
	str unitTestRank = rankUnitTest(densityRank, mcCabeRank);
	
	println(
	"
	assertionDensity: <assertionDensity> rank: <densityRank>
	assertionMcCabe: <assertionMcCabe> rank: <mcCabeRank>
	Unit Test Rank (average): <unitTestRank>
	");
	
	tuple[str volume, str complexity, str unitVolume, str duplication, str unitInterfacing, str unitTest] ranks = < volumeRank, complexityRank, unitVolumeRank, duplicationRank, interfacingRank, unitTestRank>;
	//println(ranks);
	
	set[Declaration] projectClasses = getClasses(asts);
	
	map[loc classSrc, int totalCC] wmcMap = calculateWMC(projectClasses);
	
	list[int] ccPerClass = [];
	
	for (class <- wmcMap) {
		ccPerClass += wmcMap[class];
	}
	
	ccPerClass = reverse(sort(ccPerClass));
	
	int maxClassCC = max(ccPerClass);
	int totalClassCC = sum(ccPerClass);
	real averageClassCC = totalClassCC / toReal(size(projectClasses));
	
	map [int totalCC, set[loc] classes] wmcInvert = invert(wmcMap);
	
	println("
	
	========= WMC ==========
	
	MAX:<maxClassCC>  TOTAL:<totalClassCC> AVERAGE:<averageClassCC>
	");
	
	for (i <- [0 .. 3]) {
		
		iprintln("<ccPerClass[i]> - <wmcInvert[ccPerClass[i]]>");
	}
	
	println("
	
	========= FINAL RANKINGS ==========
	
	
	These rankings only include analysability, changeability and testability. The unit test metric is excluded. 
	");
	
	str analysabilityRank = rankAnalysability(ranks.volume, ranks.duplication, ranks.unitVolume);
	str changeabilityRank = rankChangeability(ranks.complexity, ranks.duplication);
	str testabilityRank = rankTestability(ranks.complexity, ranks.unitVolume);
	
	println("Project wide Analysability ranking: <analysabilityRank>");
	println("Project wide Changeability ranking: <changeabilityRank>");
	println("Project wide Testability ranking: <testabilityRank>");
	
	str maintainabilityRank = rankMaintainability(analysabilityRank, changeabilityRank, testabilityRank);
	
	println("Maintainability rank: <maintainabilityRank>");
	
	println("
	
	========= FINAL RANKINGS (WITH UNIT TESTING) ==========
	
	");
	
	analysabilityRank = rankAnalysabilityBonus(ranks.volume, ranks.duplication, ranks.unitVolume, ranks.unitTest);
	changeabilityRank = rankChangeability(ranks.complexity, ranks.duplication);
	testabilityRank = rankTestabilityBonus(ranks.complexity, ranks.unitVolume, ranks.unitTest);
	stabilityRank = rankStability(ranks.unitTest);
	
	println("Project wide Analysability ranking: <analysabilityRank>");
	println("Project wide Changeability ranking: <changeabilityRank>");
	println("Project wide Testability ranking: <testabilityRank>");
	println("Project wide Stability ranking: <stabilityRank>");
	
	maintainabilityRank = rankMaintainabilityBonus(analysabilityRank, changeabilityRank, stabilityRank, testabilityRank);
	println("Maintainability rank: <maintainabilityRank>");
	
	println("
	
	========= FINAL RANKINGS (WITH UNIT TESTING/UNIT INTERFACING) ==========
	
	");
	
	analysabilityRank = rankAnalysabilityBonus(ranks.volume, ranks.duplication, ranks.unitVolume, ranks.unitTest);
	changeabilityRank = rankChangeability(ranks.complexity, ranks.duplication);
	testabilityRank = rankTestabilityBonus(ranks.complexity, ranks.unitVolume, ranks.unitTest);
	stabilityRank = rankStability(ranks.unitTest);
	str reusabilityRank = rankReusability(ranks.unitInterfacing, ranks.unitVolume);
	
	println("Project wide Analysability ranking: <analysabilityRank>");
	println("Project wide Changeability ranking: <changeabilityRank>");
	println("Project wide Testability ranking: <testabilityRank>");
	println("Project wide Stability ranking: <stabilityRank>");
	println("Project wide Reusability ranking: <reusabilityRank>");
	
	maintainabilityRank = rankMaintainabilityBonus(analysabilityRank, changeabilityRank, stabilityRank, testabilityRank, reusabilityRank);
	println("Maintainability rank: <maintainabilityRank>");
	
}

void makeReportSmall(){
	println(benchmark( ("Smallsql" : void() {main(|project://smallsql0.21_src|);})));
}

void makeReportBig(){
	println(benchmark( ("BIGSQL" : void() {main(|project://hsqldb-2.3.1|);})));
}

void makeReportAll(){
	println(" *************************************************** SMALLSQL *************************************************** 
	
	");
	makeReportSmall();
	println(" *************************************************** HSQLDB *************************************************** 
	
	");
	makeReportBig();
}
