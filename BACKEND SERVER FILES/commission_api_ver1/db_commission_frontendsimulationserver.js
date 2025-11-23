/**
 * FRONTEND SIMULATION (Integrated)
 * Combines Fritzie's UI Logic with Server API Calls.
 */

const API_URL = 'http://localhost:3000/api';

let AllowEdit = false;
let ActionType = null;
let SelectedOrderID = null; 

const ACTION_EDIT = "EDIT";
const ACTION_CANCEL = "CANCEL_ORDER";

const wait = (ms) => new Promise(resolve => setTimeout(resolve, ms));


async function apiCall(endpoint, method, body = null) {
    try {
        const options = {
            method: method,
            headers: { 'Content-Type': 'application/json' }
        };
        if (body) options.body = JSON.stringify(body);
        
        const response = await fetch(`${API_URL}${endpoint}`, options);
        const data = await response.json();
        return data;
    } catch (err) {
        console.error(`❌ Network Error on ${endpoint}:`, err.message);
    }
}

async function viewTracker() {
    console.log("\n👀 [UI] Loading Project Tracker View...");
    const data = await apiCall('/view_projecttrackerlist', 'GET'); // Using your new route name
    console.table(data);
}

/**
 * Scenario: User clicks "Edit", changes details, and clicks "Save".
 */
async function handleEditClick(orderId, newLabel, newContact) {
    console.log(`\n🖱️ [USER CLICK] 'Edit' on Order ${orderId}`);
    
    // 1. Fritzie's Logic
    SelectedOrderID = orderId;
    ActionType = ACTION_EDIT;
    AllowEdit = true; 

    console.log(`   -> UI State: ActionType=${ActionType}, AllowEdit=${AllowEdit}`);
    console.log(`   -> Opening Edit Form...`);
    await wait(500);

    // 2. Simulate User Typing
    console.log(`   ✍️ [USER INPUT] User is typing: "${newLabel}"...`);
    
    // 3. API Call (Saving the data)
    const result = await apiCall('/orders/edit', 'PUT', {
        orderId: orderId,
        newOrderLabel: newLabel,
        newClientContact: newContact
    });
    console.log(`   ✅ [SERVER RESPONSE] ${result.message}`);
    
    // Reset State
    AllowEdit = false;
    ActionType = null;
}

/**
 * Scenario: User clicks "Cancel", sees popup, confirms "Yes".
 */
async function handleCancelClick(orderId) {
    console.log(`\n🖱️ [USER CLICK] 'Cancel' on Order ${orderId}`);

    SelectedOrderID = orderId;
    ActionType = ACTION_CANCEL;
    AllowEdit = false; 
    
    console.log(`   -> UI State: ActionType=${ActionType}, AllowEdit=${AllowEdit}`);

    if (confirmCancellation(orderId)) {
        console.log(`   👍 [USER CONFIRM] "Yes, cancel it."`);
        
        const result = await apiCall('/orders/cancel', 'POST', { orderId: orderId });
        console.log(`   ✅ [SERVER RESPONSE] ${result.message}`);
    } else {
        console.log(`   🚫 [USER] Cancellation aborted.`);
    }
}

function confirmCancellation(orderId) {
    return true; 
}

async function handleFinalizeAll() {
    console.log(`\n🖱️ [USER CLICK] 'Finalize All Orders'`);
    const result = await apiCall('/orders/finalize', 'POST');
    console.log(`   ✅ [SERVER RESPONSE] ${result.message}`);
}


async function runFullSimulation() {
    console.log("=== APP STARTED ===");

    // 1. Shaine checks the list
    await viewTracker();
    await wait(1000);

    // 2. Fritzie clicks Edit on Order 12345
    await handleEditClick(12345, "UPDATED: Capybara Keychain RUSH", "09123456789");
    await wait(1000);

    // 3. Fritzie clicks Cancel on Order 12346
    await handleCancelClick(12346);
    await wait(1000);

    // 4. Verify changes in the view
    await viewTracker();
    await wait(1000);

    // 5. Franchesca Finalizes everything
    await handleFinalizeAll();
    await wait(1000);

    // 6. Final Check
    await viewTracker();
    
    console.log("\n=== SIMULATION COMPLETE ===");
}

runFullSimulation();