document.addEventListener('DOMContentLoaded', function () {
  var images = [
    '/assets/images/portfolio-md.svg',
    '/assets/images/portfolio-lab.svg',
    '/assets/images/portfolio-lab.svg',
    '/assets/images/portfolio-visualization.svg'
  ];

  document.querySelectorAll('.project-card').forEach(function (card, index) {
    if (card.querySelector('.project-visual')) return;
    var image = document.createElement('img');
    image.className = 'project-visual';
    image.src = images[index % images.length];
    image.alt = 'Research portfolio visual';
    card.insertBefore(image, card.firstChild);
  });
});
