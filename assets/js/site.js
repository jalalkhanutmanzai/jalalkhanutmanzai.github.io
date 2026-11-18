document.querySelectorAll('.project-filters').forEach(group => {
 group.hidden = false;
 group.addEventListener('click', e => {
 const button = e.target.closest('button[data-filter]');
 if (!button) return;
 group.querySelectorAll('button').forEach(b => b.setAttribute('aria-pressed', String(b === button)));
 let count = 0;
 document.querySelectorAll('#projects .project-card').forEach(card => {
 card.hidden = button.dataset.filter !== 'all' && !card.dataset.category.split(' ').includes(button.dataset.filter);
 if (!card.hidden) count++;
 });
 document.querySelector('.filter-status').textContent = count + ' research projects shown';
 });
});
const toggle = document.querySelector('.menu-toggle');
const nav = document.querySelector('.site-nav');
if(toggle && nav) {
 toggle.hidden = false;
 const close = () => { toggle.setAttribute('aria-expanded','false'); nav.classList.remove('is-open'); };
 toggle.addEventListener('click',()=>{const open = toggle.getAttribute('aria-expanded') !== 'true'; toggle.setAttribute('aria-expanded',String(open)); nav.classList.toggle('is-open',open);});
 nav.addEventListener('click',e=>{if(e.target.closest('a'))close();});
 document.addEventListener('keydown',e=>{if(e.key==='Escape' && toggle.getAttribute('aria-expanded')==='true'){close();toggle.focus();}});
}

