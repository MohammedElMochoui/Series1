module Testing::WMCTests

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
import main;

import util::Math;
import util::Benchmark;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void test1(){
	M3 model = createM3FromEclipseProject(|project://WMCTests1|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
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
	
	assert maxClassCC == 1;
	assert totalClassCC == 1;
	assert averageClassCC == 1;
}

void test2(){
	M3 model = createM3FromEclipseProject(|project://WMCTests2|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
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
	
	assert maxClassCC == 1;
	assert totalClassCC == 2;
	assert averageClassCC == 1;
}


void test3(){
	M3 model = createM3FromEclipseProject(|project://WMCTests3|);
	list[Declaration] asts = getASTs(model);
	set[Declaration] projectMethods = getMethods(asts);
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
		
	assert maxClassCC == 3;
	assert totalClassCC == 4;
	assert averageClassCC == 2;
}

void runWMCTests(){
	test1();
	test2();
	test3();
}