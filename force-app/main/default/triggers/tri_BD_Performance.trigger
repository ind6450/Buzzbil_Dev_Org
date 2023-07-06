/*
* ---------------------------------------------------------------------
*
* Subject : BD_Performance__c Trigger
*
* Tester : tri_InventoryHandler_test
* Description :
*
* ---------------------------------------------------------------------
*/
trigger tri_BD_Performance on BD_Performance__c (before update, before delete, after update, after delete, after undelete) {

		new tri_BD_PerformanceHandler().run();

}