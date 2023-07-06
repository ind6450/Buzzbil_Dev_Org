/*
* ---------------------------------------------------------------------
*
* Subject : Case Trigger
*
* Tester : tri_CaseHandler_test
* Description :
*
* ---------------------------------------------------------------------
*/
trigger tri_Case on Case (before insert, after insert, before update, after update, after delete) {
  new tri_CaseHandler().run();
}