import random


class Board:
    def __init__(self):
        # Initialisiere das Spielfeld mit None-Werten für jedes Feld (tile=Fliesse)
        self.tiles = {0: None, 1: None, 2: None,
                      3: None, 4: None, 5: None,
                      6: None, 7: None, 8: None}

    def update_board(self, choice, player_symbol):
        # Aktualisiere das gewählte Feld mit dem Symbol des Spielers
        self.tiles[choice] = player_symbol

    # Überprüfe, ob ein Spieler gewonnen hat
    def has_won(self, player_symbol):
        # Gewinnkombinationen im Tic-Tac-Toe
        win_combinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  # horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  # vertikal
            [0, 4, 8], [2, 4, 6]              # diagonal
        ]
        for combo in win_combinations:
            if all(self.tiles[pos] == player_symbol for pos in combo):
                return True
        return False

    # Überprüfe, ob das Spielfeld voll ist
    def board_is_full(self):
        return all(self.tiles[pos] is not None for pos in self.tiles)

    def show(self):
        # Zeige das aktuelle Spielfeld an
        board_display = [self.tiles[i] if self.tiles[i] is not None else i for i in range(9)]
        print("{} | {} | {}\n{} | {} | {}\n{} | {} | {}\n".format(
            board_display[0], board_display[1], board_display[2],
            board_display[3], board_display[4], board_display[5],
            board_display[6], board_display[7], board_display[8]
        ))


class Player:
    def __init__(self, name, player_symbol):
        self.name = name
        self.player_symbol = player_symbol

    def get_move(self, board):
        raise NotImplementedError  # heisst: die folgenden child classes sollen
                                # die parent Methode überschreiben und implementieren

class Human(Player): # Mensch, Spieler ist player1
    def __init__(self, name="Spieler", player_symbol="\033[92mX\033[0m"): # statt nur X gibt es ein grünes X aus
        super().__init__(name, player_symbol)

    def get_move(self, board):
        # Fordere den Spieler zur Eingabe auf und überprüfe die Gültigkeit der Eingabe
        while True:
            try:
                choice = int(input(f"{self.name}, gib dein Feld (0-8) ein: "))
                if choice in board.tiles and board.tiles[choice] is None:
                    return choice
                else:
                    print("Ungültiger Zug. Bitte erneut versuchen.")
            except ValueError:
                print("Bitte eine Zahl zwischen 0 und 8 eingeben.")


class Computer(Player): # Computer ist player2
    def __init__(self, name="Computer", player_symbol="\033[91mO\033[0m"): # statt nur O gibt es ein rotes O aus
        super().__init__(name, player_symbol)

    def get_move(self, board):
        # Wähle einen zufälligen Zug aus den verfügbaren Feldern
        available_moves = [pos for pos in board.tiles if board.tiles[pos] is None]
        return random.choice(available_moves)


class Game:
    def __init__(self, player1, player2):
        self.board = Board()
        self.player1 = player1 # Mensch, Spieler
        self.player2 = player2 # Computer
        self.current_player = player1  # Der erste Spieler beginnt

    # Überprüfe, ob das Spiel vorbei ist
    def game_over(self):
        return self.board.board_is_full() or self.board.has_won(self.player1.player_symbol) or self.board.has_won(self.player2.player_symbol)

    # Führe den Zug des aktuellen Spielers aus
    def make_move(self, player):
        self.board.show()
        choice = player.get_move(self.board)
        self.board.update_board(choice, player.player_symbol)

    # Hauptspielschleife
    def play(self):
        print("Willkommen bei Tic Tac Toe!")
        while not self.game_over():
            print(f"\n{self.current_player.name} ist am Zug ({self.current_player.player_symbol}):")
            self.make_move(self.current_player)

            # Überprüfe, ob der aktuelle Spieler gewonnen hat
            if self.board.has_won(self.current_player.player_symbol):
                self.board.show()
                print(f"Herzlichen Glückwunsch {self.current_player.name}! Du hast das Spiel gewonnen.")
                return

            # Wechsle den Spieler
            self.current_player = self.player1 if self.current_player == self.player2 else self.player2

        # Falls das Spiel unentschieden endet
        self.board.show()
        print("Das Spiel endet unentschieden!")


def main():
    spieler = Human()
    computer = Computer()
    spiel = Game(spieler, computer)
    spiel.play()


if __name__ == '__main__':
    main()
