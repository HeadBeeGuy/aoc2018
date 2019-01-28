// Part 2 asks to swell the game to ten times its size.
// I tried implementing my code from Part 1 in Rust, but it became apparent
// that my algorithm is at fault and not the language I was using. I'll need
// to implement something else! Maybe a linked list?

use std::collections::HashMap;

fn main() {
    let ending_marble = 71032;
    let player_count = 441;

    println!("This game will have {} players and end at marble {}", player_count, ending_marble);

    let mut players: HashMap<i32, i128> = HashMap::new();

    // initialize score hash, but this may be unnecessary
    for i in 1..=player_count {
        players.insert(i, 0);
    }

    let mut circle: Vec<i128> = Vec::new();

    circle.push(0);

    let mut new_marble_number = 1;
    let mut current_player_number = 1;
    let mut current_marble_index = 1;

    circle.push(new_marble_number);
    new_marble_number += 1;

    for _i in 2..=ending_marble {
        current_player_number = 1 + ( current_player_number % player_count);

        if new_marble_number % 23 == 0 {
            // println!("We found a marble that's a multiple of 23!");
            // dbg!(current_marble_index);
            let mut remove_at_this_index = 0;
            if current_marble_index > 8 {
                remove_at_this_index = current_marble_index - 7;
            } else {
                remove_at_this_index = circle.len() + current_marble_index - 7;
            }

            current_marble_index = remove_at_this_index;
            let new_points = new_marble_number + circle[remove_at_this_index];
            // println!("Player {} will receive {} points!", current_player_number, new_points);
            if let Some(x) = players.get_mut(&current_player_number) {
                *x += new_points;
            }
            circle.remove(remove_at_this_index);
        } else {
            if current_marble_index + 1 >= circle.len() {
                circle.insert(1, new_marble_number);
                current_marble_index = 1;
            } else {
                circle.insert(current_marble_index + 2, new_marble_number);
                current_marble_index += 2;
            }
        }

        new_marble_number += 1;
    }

    let max_score = players.values().max();

    println!("The max score is: {:?}", max_score);

}
