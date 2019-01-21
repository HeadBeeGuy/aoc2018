use std::fs;

fn sum_toplevel(base_tree: &[i32], start_index: i32, metadata_total: &mut i32) -> i32 {
    let children_count = base_tree[start_index as usize];
    let metadata_count = base_tree[(start_index as usize) + 1];
    // println!("I detect {} children and {} metadata entries.", children_count, metadata_count);

    if children_count == 0 {
        // We can assume that entries after the metadata account are metadata entries,
        // which can be added to our final total.
        // println!("We've bottomed out. Time to add up the metadata entries.");
        // there's probably a way to do this with iterators but I haven't learned much about them yet
        for metadata_position in (start_index + 2)..(start_index + metadata_count + 2) {
            dbg!(base_tree[metadata_position as usize]);
            *metadata_total += base_tree[metadata_position as usize];
            dbg!(&metadata_total);
        }
        metadata_count + 2
    } else if children_count >= 1 {
        let mut current_child_index: i32 = 2;
        for i in 1..=children_count {
            // println!("i is: {}", i);
            current_child_index += sum_toplevel(base_tree, start_index + current_child_index, metadata_total);
        }
        if metadata_count == 1 {
            *metadata_total += base_tree[(start_index + current_child_index) as usize];
        }
        else {
            // iterate from the beginning of where the metadata is up to its end
            let metadata_begin = start_index + current_child_index + 1;
            let metadata_end = start_index + current_child_index + metadata_count;
            for i in metadata_begin..=metadata_end {
                dbg!( base_tree[ i as usize ]);
                *metadata_total += base_tree[i as usize];
            }
        }
        current_child_index
    } else {
        0
    }
}

fn main() {
    let data = fs::read_to_string("../input.txt").expect("Unable to read that file.");
    let mut metadata_total: i32 = 0;
    
    // swiped from https://stackoverflow.com/a/26537398
    let num_array: Vec<i32> = data.split_whitespace().map(|s| s.parse().unwrap() ).collect();

    sum_toplevel(&num_array, 0, &mut metadata_total);

    println!("I think the final metadata total is: {}", metadata_total);


}
