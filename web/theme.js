// Simple Theme Toggle Functionality
document.addEventListener('DOMContentLoaded', function() {
    console.log("Theme script loaded");
    
    // Get theme toggle button
    const themeToggle = document.getElementById('theme-toggle');
    if (!themeToggle) {
        console.error("Theme toggle button not found");
        return;
    }
    
    const htmlElement = document.documentElement;
    const themeIcon = themeToggle.querySelector('i');
    const themeText = themeToggle.querySelector('.theme-text');
    
    // Check for saved theme preference or use default dark theme
    const savedTheme = localStorage.getItem('theme') || 'dark';
    
    // Set initial theme
    htmlElement.classList.remove('light-theme', 'dark-theme');
    htmlElement.classList.add(savedTheme + '-theme');
    updateThemeUI(savedTheme);
    
    // Handle theme toggle click
    themeToggle.addEventListener('click', function() {
        // Toggle between dark and light
        const currentTheme = htmlElement.classList.contains('light-theme') ? 'dark' : 'light';
        
        // Remove any existing theme classes
        htmlElement.classList.remove('light-theme', 'dark-theme');
        
        // Add the new theme class
        htmlElement.classList.add(currentTheme + '-theme');
        
        // Save preference to local storage
        localStorage.setItem('theme', currentTheme);
        
        // Update button UI
        updateThemeUI(currentTheme);
    });
    
    function updateThemeUI(theme) {
        if (theme === 'light') {
            themeIcon.className = 'bx bx-sun';
            themeText.textContent = 'Dark Mode';
        } else {
            themeIcon.className = 'bx bx-moon';
            themeText.textContent = 'Light Mode';
        }
    }
});