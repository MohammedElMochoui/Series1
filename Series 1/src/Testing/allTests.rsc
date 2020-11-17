module Testing::allTests

import Testing::volumeTests;
import Testing::complexityTests;
import Testing::duplicationTests;
import Testing::interfacingTests;
import Testing::unitSizeTests;
import Testing::unitTestingTests; 
import Testing::WMCTests;

void runAllTests(){
	runComplexityTests();
	runDuplicationTests();
	runVolumeTests();
	runInterfacingTests();
	runUnitSizeTests();
	runUnitTestingTests;
	runWMCTests();
}