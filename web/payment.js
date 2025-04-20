// For Debit/Credit Card Number 
function formatCardNumber(input) {
   
    let digits = input.value.replace(/\D/g, '');

   
    digits = digits.substring(0, 16);

    
    let formatted = digits.replace(/(.{4})/g, '$1 ').trim();

 
    input.value = formatted;
}

// If user choose debit/credit card , it will display card details
function togglePayment(method) {
    const cardSection = document.getElementById("cardDetails");

   
    if (method === "card") {
        cardSection.style.display = "block";
    } else {
        cardSection.style.display = "none";
    }
}

// Format expiry date as MM/YY with valid month (01–12)
document.addEventListener('DOMContentLoaded', function () {
    const expiryInput = document.getElementById('expiry');

    if (expiryInput) {
        expiryInput.addEventListener('input', function (e) {
            let input = e.target.value.replace(/\D/g, '');

            // Only check when at least 1 or 2 digits are typed
            if (input.length >= 1) {
                let month = input.substring(0, 2);

                // Fix invalid month values
                if (parseInt(month) > 12) {
                    month = '12';
                } else if (month.length === 1 && parseInt(month) > 1) {
                    // Auto-correct for single-digit month like 4 -> 04
                    month = '0' + month;
                }
                
                input = month + input.substring(2, 4);

                if (input.length > 2) {
                    input = input.substring(0, 2) + '/' + input.substring(2, 4);
                }
            }

            e.target.value = input;
        });

        expiryInput.addEventListener('keydown', function (e) {
            const key = e.key;
            if ((key === 'Backspace' || key === 'Delete') && expiryInput.value.length === 3) {
                expiryInput.value = expiryInput.value.slice(0, 2);
            }
        });
    }
});


// Get the postal input field
let postalInput = document.getElementById("postal");

// Add an event listener that runs whenever the user types something
postalInput.addEventListener("input", function(event) {
    // Replace anything that's not a number (0–9) with an empty string
    event.target.value = event.target.value.replace(/[^0-9]/g, "");
});


// Get the cvv input
let cvvInput = document.getElementById("cvv");

// Add an event listener that runs whenever the user types something
cvvInput.addEventListener("input", function(event) {
    // Replace anything that's not a number (0–9) with an empty string
    event.target.value = event.target.value.replace(/[^0-9]/g, "");
});




