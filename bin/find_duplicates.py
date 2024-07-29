import os
import argparse
import hashlib
from tqdm import tqdm
import pandas as pd
import glob

def get_file_hash(file_path, chunk_size=65535):
    """Compute SHA-256 hash of the file."""
    sha256 = hashlib.sha256()
    with open(file_path, 'rb') as f:
        chunk = f.read(chunk_size)
        sha256.update(chunk)

    file_size = os.path.getsize(file_path)
    sha256.update(str(file_size).encode('utf-8'))

    return sha256.hexdigest()

def find_duplicates(folder_path):
    """Find and list duplicate files in the given folder."""
    file_hashes = {}
    duplicates = []

    all_files = glob.glob(f'{folder_path}/**/*', recursive=True)
    all_files = [f for f in all_files if os.path.isfile(f)]

    # Process files with progress bar
    for file_path in tqdm(all_files, desc="Processing files", unit="file"):
        file_hash = get_file_hash(file_path)
        fp = file_path.replace(folder_path, "").lstrip("/")
        if file_hash in file_hashes:
            file_hashes[file_hash].append(fp)
        else:
            file_hashes[file_hash] = [fp]

    # Extract duplicates
    for file_paths in file_hashes.values():
        if len(file_paths) > 1:
            duplicates.append(file_paths)

    return duplicates

def main():
    parser = argparse.ArgumentParser(
        description='Find duplicate files in a folder and save the list to a Parquet file.',
        epilog='Example: python find_duplicates.py --path /path/to/folder --output duplicates.parquet'
    )
    parser.add_argument('--path', type=str, required=True, help='Path to the folder to scan for duplicates.')
    parser.add_argument('--output', type=str, required=True, help='Output Parquet file to save the duplicate files list.')

    args = parser.parse_args()

    folder_path = args.path
    output_file = args.output

    duplicates = find_duplicates(folder_path)

    # Convert the list of duplicates to a DataFrame
    df_duplicates = pd.DataFrame({'duplicates': duplicates})

    # Save DataFrame to Parquet file
    df_duplicates.to_parquet(output_file)

if __name__ == "__main__":
    main()
