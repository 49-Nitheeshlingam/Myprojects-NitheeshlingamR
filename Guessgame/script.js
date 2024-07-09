let randomNumber = Math.floor(Math.random()*20);
let hiddenNumber = randomNumber;
let score = 20;
let highScore = 0;
document.getElementById("startBtn").addEventListener("click",function(){

    let userInput = document.getElementById("userInput").value;
    
    if(!userInput){
        alert("Please Enter a Number");
        document.querySelector(".message").innerText = "Plz Enter a Number";
    }
    else if(userInput == hiddenNumber){
        document.querySelector(".message").innerText = "Correct You Won 🎉✨";
        document.querySelector("#startBtn").style.display = "none";
        document.querySelector("body").style.backgroundColor = "#21e821";
        document.querySelector(".number").innerText = hiddenNumber;

        if(score>highScore){
            highScore = score;
            document.querySelector(".highscore").innerText=highScore;
        }
    }
    else if(userInput < hiddenNumber){
        if(score==0){
            document.querySelector("body").style.backgroundColor="red";
            document.querySelector(".message").innerText = "Game Over 😔";
            document.querySelector(".number").innerText = hiddenNumber;
            document.querySelector(".check").style.display = "none";
        }
        else{
            document.querySelector(".message").innerText = "Too Low 🥴";
            score--;
            document.querySelector(".score").innerText = score;
        }
    }
    else{
        if(score==0){
            document.querySelector("body").style.backgroundColor="red";
            document.querySelector(".message").innerText = "Game Over 😔";
            document.querySelector(".number").innerText = hiddenNumber;
            document.querySelector(".check").style.display = "none";
        }
        else{
            document.querySelector(".message").innerText = "Too High 😱";
            score--;
            document.querySelector(".score").innerText = score;
        }
    }


});
document.getElementById('againBtn').addEventListener('click', function(){
    document.getElementById('userInput').value = null;
    document.getElementById('highscore').innerText = highScore;
    document.querySelector("#startBtn").style.display = "inline";
    score = 20;
    document.getElementById('score').textContent = score;
    document.getElementById('check').textContent = "Start guessing...";
    document.querySelector('body').style.backgroundColor = '#222';
    document.getElementById('number').innerText = "?";
    randomNumber= Math.floor(Math.random() * 20);
    hiddenNumber = randomNumber
});