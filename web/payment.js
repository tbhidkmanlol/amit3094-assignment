// For Debit/Credit Card Number 
function formatCardNumber(input) {
    let digits = input.value.replace(/\D/g, '');
    digits = digits.substring(0, 16);
    let formatted = digits.replace(/(.{4})/g, '$1 ').trim();
    input.value = formatted;
}

// If user choose debit/credit card, it will display card details
function togglePayment(method) {
    const cardSection = document.getElementById("cardDetails");
    const ewalletSection = document.getElementById("ewalletDetails");
    const cashSection = document.getElementById("cashDetails");
    
    // Hide all sections first
    cardSection.style.display = "none";
    if (ewalletSection) ewalletSection.style.display = "none";
    if (cashSection) cashSection.style.display = "none";
    
    // Show the appropriate section
    if (method === "card" || method === "creditCard") {
        cardSection.style.display = "block";
    } else if (method === "ewallet") {
        if (ewalletSection) ewalletSection.style.display = "block";
    } else if (method === "cash") {
        if (cashSection) cashSection.style.display = "block";
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

                // Format with slash after month
                if (input.length > 2) {
                    input = input.substring(0, 2) + '/' + input.substring(2);
                }

                e.target.value = input;
            }
        });
    }
    
    // Initialize payment method selection
    const paymentRadios = document.querySelectorAll('input[name="paymentMethod"]');
    if (paymentRadios.length > 0) {
        // Check if a payment option is already selected (e.g. on page reload)
        let selectedMethod = Array.from(paymentRadios).find(radio => radio.checked);
        if (selectedMethod) {
            togglePayment(selectedMethod.value);
        }
        
        // Add event listeners to payment method radios
        paymentRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                togglePayment(this.value);
            });
        });
    }
});

// Payment Method Selection
document.addEventListener('DOMContentLoaded', function() {
    // Payment method selection
    const paymentOptions = document.querySelectorAll('.payment-option');
    const paymentMethodInput = document.getElementById('method');
    const methodValidation = document.getElementById('method-validation');
    
    // Add click event listeners to payment options
    paymentOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Remove selected class from all options
            paymentOptions.forEach(opt => {
                opt.classList.remove('selected');
                opt.classList.remove('active');
            });
            
            // Add selected class to clicked option
            this.classList.add('selected');
            this.classList.add('active');
            
            // Update hidden input value
            const method = this.getAttribute('data-method');
            paymentMethodInput.value = method;
            
            // Hide validation message if a method is selected
            methodValidation.classList.remove('show');
            
            // Show/hide appropriate payment details section
            togglePayment(method);
            
            // Add animation effect to selected option
            this.style.transform = 'scale(1.05)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 200);
        });
    });

    // Form validation
    const paymentForm = document.getElementById('paymentForm');
    if (paymentForm) {
        paymentForm.addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validate payment method selection
            if (!paymentMethodInput.value) {
                methodValidation.classList.add('show');
                isValid = false;
                
                // Highlight payment options section with a subtle animation
                const methodsContainer = document.querySelector('.payment-method-buttons');
                methodsContainer.style.animation = 'pulse 1s';
                setTimeout(() => {
                    methodsContainer.style.animation = '';
                }, 1000);
            }
            
            // Add more validation as needed for each payment method
            if (paymentMethodInput.value === 'creditCard') {
                // Add credit card validation logic here
                const cardName = document.getElementById('cardName');
                const cardNumber = document.getElementById('cardNumber');
                const expiry = document.getElementById('expiry');
                const cvv = document.getElementById('cvv');
                
                if (cardName && !cardName.value.trim()) {
                    document.getElementById('cardName-validation').classList.add('show');
                    isValid = false;
                }
                
                if (cardNumber && (cardNumber.value.trim().length < 19)) {
                    document.getElementById('cardNumber-validation').classList.add('show');
                    isValid = false;
                }
                
                if (expiry && !(/^\d{2}\/\d{2}$/.test(expiry.value))) {
                    document.getElementById('expiry-validation').classList.add('show');
                    isValid = false;
                }
                
                if (cvv && (cvv.value.trim().length < 3 || cvv.value.trim().length > 4)) {
                    document.getElementById('cvv-validation').classList.add('show');
                    isValid = false;
                }
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
    }
    
    // Theme toggle functionality
    const themeToggle = document.querySelector('.theme-toggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            document.documentElement.classList.toggle('light-theme');
            
            // Update icon
            const icon = this.querySelector('i');
            if (document.documentElement.classList.contains('light-theme')) {
                icon.className = 'fas fa-moon';
            } else {
                icon.className = 'fas fa-sun';
            }
            
            // Update payment option colors based on theme
            updatePaymentOptionColors();
        });
    }
    
    // Function to update payment option colors based on theme
    function updatePaymentOptionColors() {
        const isDarkTheme = !document.documentElement.classList.contains('light-theme');
        const options = document.querySelectorAll('.payment-option');
        
        options.forEach(option => {
            if (isDarkTheme) {
                option.style.backgroundColor = '#222';
                option.style.borderColor = '#444';
            } else {
                option.style.backgroundColor = '#f9f9f9';
                option.style.borderColor = '#ddd';
            }
            
            if (option.classList.contains('selected') || option.classList.contains('active')) {
                option.style.borderColor = '#007bff';
                option.style.backgroundColor = isDarkTheme ? '#1a3658' : '#e6f2ff';
            }
        });
    }
    
    // Initial update of payment option colors
    updatePaymentOptionColors();
});

// Get the postal input field
let postalInput = document.getElementById("postal");
if (postalInput) {
    // Add an event listener that runs whenever the user types something
    postalInput.addEventListener("input", function(event) {
        // Replace anything that's not a number (0–9) with an empty string
        event.target.value = event.target.value.replace(/[^0-9]/g, "");
    });
}

// Get the cvv input
let cvvInput = document.getElementById("cvv");
if (cvvInput) {
    // Add an event listener that runs whenever the user types something
    cvvInput.addEventListener("input", function(event) {
        // Replace anything that's not a number (0–9) with an empty string
        event.target.value = event.target.value.replace(/[^0-9]/g, "");
        
        // Limit to 3-4 digits
        if (event.target.value.length > 4) {
            event.target.value = event.target.value.slice(0, 4);
        }
    });
}




