// Adapted from https://stackoverflow.com/questions/50970336
var tooltips = document.querySelectorAll(".tooltip-hover");
tooltips.forEach(function(ktooltip, index) {
    ktooltip.addEventListener("mouseover", position_tooltip);
});

function position_tooltip() {

    let tooltip = this.querySelector('.tooltip');
    let rect = tooltip.getBoundingClientRect();
    let hover_rect = this.getBoundingClientRect();

    const window_width = document.documentElement.clientWidth;
    if ((rect.x + rect.width) > window_width) {
        tooltip.style.left = `unset`;
        tooltip.style.right = '-5px';
        tooltip.style.transform = 'none';
    }
    else if (rect.x < 0) {
        tooltip.style.left = 0;
        tooltip.style.right = 'unset';
        tooltip.style.transform = 'none';
    }
}
