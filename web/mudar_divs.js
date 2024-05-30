const projetoBtn = document.getElementById('projeto');
const serviçoBtn = document.getElementById('serviço');
const escolhaProjetoDiv = document.querySelector('.escolhaProjeto');
const escolhaServiçoDiv = document.querySelector('.escolhaServiço');

projetoBtn.addEventListener('click', () => {
    escolhaProjetoDiv.style.display = 'block';
    escolhaServiçoDiv.style.display = 'none';
});

serviçoBtn.addEventListener('click', () => {
    escolhaServiçoDiv.style.display = 'block';
    escolhaProjetoDiv.style.display = 'none';
});