/**
 * Created by ehdgn on 2022-05-25.
 */

import { LightningElement, api, track, wire } from 'lwc';
import retrieveRecords from '@salesforce/apex/ctrlOpportunityStageChange.retrieveRecords';


const actions = [
      { label: 'Show details', name: 'show_details' },
      { label: 'Delete', name: 'delete' },
  ];

  const columns = [
      { label: 'Name', fieldName: 'name' },
      { label: 'Website', fieldName: 'website', type: 'url' },
      { label: 'Phone', fieldName: 'phone', type: 'phone' },
      { label: 'Balance', fieldName: 'amount', type: 'currency' },
      { label: 'Close At', fieldName: 'closeAt', type: 'date' },
      {
          type: 'action',
          typeAttributes: { rowActions: actions },
      },
  ];

export default class LwcOpportunityStageChange extends LightningElement {
    @track globalSelectedItems = []; //holds all the selected checkbox items

      //start: following parameters to be passed from calling component

    @api labelName;
    labelName = '목록123';

    @api objectApiName; // = 'Contact';
    objectApiName = 'Opportunity';

    @api fieldApiNames; // = 'Id,Name';
    fieldApiNames = 'Id';

    @api filterFieldApiName;    // = 'Name';
    filterFieldApiName = 'Name,StageName,recordtype.id';

    @api iconName= 'custom:custom36';

    @track items = [];//holds all records retrieving from database
    @track selectedItems = []; //holds only selected checkbox items that is being displayed based on search
    @track selectedValues = []; //holds only selected checkbox items that is being displayed based on search

    @track keyMap = new Map();
    @track selectedString;

    @track previousSelectedItems = [];
    @track value = []; //this holds checkbox values (Ids) which will be shown as selected
    searchInput ='';    //captures the text to be searched from user input
    isDialogDisplay = false; //based on this flag dialog box will be displayed with checkbox items
    isDisplayMessage = false; //to show 'No records found' message
    @track productId;

    ///////////////////////////////////////////////////////////////////////////////////


      data = [];
      columns = columns;
      record = {};

      // eslint-disable-next-line @lwc/lwc/no-async-await
      async connectedCallback() {
//          this.data = await fetchDataHelper({ amountOfRecords: 100 });
        retrieveRecords({objectName: this.objectApiName,
                        fieldAPINames: this.fieldApiNames,
                        filterFieldAPIName: this.filterFieldApiName,
                        strInput: this.searchInput
                        })
        .then(result=>{
            this.items = []; //initialize the array before assigning values coming from apex
            this.value = [];
            this.previousSelectedItems = [];
        if(result.length>0){
                    result.map(resElement=>{
                        //prepare items array using spread operator which will be used as checkbox options
                        this.items = [...this.items,{value:resElement.recordId,
                                                    label:resElement.recordName}];

                        /*since previously choosen items to be retained, so create value array for checkbox group.
                            This value will be directly assigned as checkbox value & will be displayed as checked.
                        */
                        this.globalSelectedItems.map(element =>{
                            if(element.value == resElement.recordId){
                                this.value.push(element.value);
                                this.previousSelectedItems.push(element);
                            }
                        });
                        this.setValues();
                    });
                    this.isDialogDisplay = true; //display dialog
                    this.isDisplayMessage = false;
                }
                else{
                    //display No records found message
                    this.isDialogDisplay = false;
                    this.isDisplayMessage = true;
                }
            })
            .catch(error=>{
                this.error = error;
                this.items = undefined;
                this.isDialogDisplay = false;
            })
        }

//      handleRowAction(event) {
//          const actionName = event.detail.action.name;
//          const row = event.detail.row;
//          switch (actionName) {
//              case 'delete':
//                  this.deleteRow(row);
//                  break;
//              case 'show_details':
//                  this.showRowDetails(row);
//                  break;
//              default:
//          }
//      }
//
//      deleteRow(row) {
//          const { id } = row;
//          const index = this.findRowIndexById(id);
//          if (index !== -1) {
//              this.data = this.data
//                  .slice(0, index)
//                  .concat(this.data.slice(index + 1));
//          }
//      }
//
//      findRowIndexById(id) {
//          let ret = -1;
//          this.data.some((row, index) => {
//              if (row.id === id) {
//                  ret = index;
//                  return true;
//              }
//              return false;
//          });
//          return ret;
//      }
//
//      showRowDetails(row) {
//          this.record = row;
//      }
  }