module Testing::unitSizeTests

import Helpers;
import main;

import Set;
import IO;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void unitSizeTests(){
	M3 model = createM3FromEclipseProject(|project://unitSizeTests|);
	list[Declaration] asts = getASTs(model);
	list[Declaration] projectMethods = toList(getMethods(asts));

	for (method <- projectMethods) {
	
		int lines = countLinesOfCode(method.src);
	
		tuple[int low, int moderate, int high, int veryHigh] unitSizeCatagories = catagorizeUnitSize(countLinesOfCode(method.src));
		unitSizeCatagories[0] = unitSizeCatagories[0] / lines * 100;
		unitSizeCatagories[1] = unitSizeCatagories[1] / lines * 100;
		unitSizeCatagories[2] = unitSizeCatagories[2] / lines * 100;
		unitSizeCatagories[3] = unitSizeCatagories[3] / lines * 100;
	
		if (contains(method.src.file, "1")) assert unitSizeCatagories.low == 100;
		if (contains(method.src.file, "2")) assert unitSizeCatagories.moderate == 100;
		if (contains(method.src.file, "3")) assert unitSizeCatagories.high == 100;
		if (contains(method.src.file, "4")) assert unitSizeCatagories.veryHigh == 100;
	}
}

void runUnitSizeTests(){
	unitSizeTests();
}