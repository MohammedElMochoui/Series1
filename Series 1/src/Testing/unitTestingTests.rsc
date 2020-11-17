module Testing::unitTestingTests

import Helpers;
import main;
import UnitTesting;

import IO;
import Set;
import List;
import Type;
import String;
import Map;

import util::Math;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void test1(){
	M3 model = createM3FromEclipseProject(|project://unitTestingTests|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
	
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
	
	real assertionDensity = (assertCount / toReal(testLOC) * 100);
	real assertionMcCabe = (assertCount / toReal(totalComplexity));

	assert assertionDensity == 0;
	assert assertionMcCabe == 0;
	
}

void test2(){
	M3 model = createM3FromEclipseProject(|project://unitTestingTests2|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
	
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
	
	real assertionDensity = (assertCount / toReal(testLOC) * 100);
	real assertionMcCabe = (assertCount / toReal(totalComplexity));
		
	assert assertionDensity == (1/6.0 * 100);
	assert assertionMcCabe == (1/1);
}

void test3(){
	M3 model = createM3FromEclipseProject(|project://unitTestingTests3|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
	
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
	
	real assertionDensity = (assertCount / toReal(testLOC) * 100);
	real assertionMcCabe = (assertCount / toReal(totalComplexity));
			
	assert assertionDensity == (1/7.0 * 100);
	assert assertionMcCabe == (1/2.0);
	
}

void runUnitTestingTests(){
	test1();
	test2();
	test3();
}