import json
import subprocess
import requests
import os
import sys
import warnings
from urllib3.exceptions import InsecureRequestWarning

# Suppresses only the InsecureRequestWarning
warnings.simplefilter('ignore', InsecureRequestWarning)

def parse_nmap_output(xml_file):
    # Call the nmap-parse-output script
    cmd = ['/root/nmap-parse-output/nmap-parse-output', xml_file, 'cpe-json']
    result = subprocess.run(cmd, capture_output=True, text=True)
    return json.loads(result.stdout)

def query_cve_search(cpe_string):
    # Formatting the CPE string for the API call
    cpe_api_string = cpe_string.replace(':', '%3A').replace('/', '%2F')
    url = f'https://127.0.0.1/api/cvefor/{cpe_api_string}?limit=15'
    headers = {'accept': 'application/json'}

    response = requests.get(url, headers=headers, verify=False)
    if response.status_code == 200:
        cve_data = response.json()
        extracted_data = []
        for cve_entry in cve_data:
            cve_id = cve_entry.get('id', 'N/A')
            cvss_score = cve_entry.get('cvss', 'N/A')
            extracted_data.append({'id': cve_id, 'cvss': cvss_score})
        return extracted_data
    else:
        return None

def save_results(filename, data):
# Generates a filename based on the input filename and numbers it if necessary
    base, ext = os.path.splitext(filename)
    output_file = f"{base}_cve_results.json"
    count = 1
    while os.path.exists(output_file):
        output_file = f"{base}_cve_results{count}.json"
        count += 1

    with open(output_file, 'w') as f:
        json.dump(data, f, indent=4)
    return output_file

def display_results(results):
    for host, services in results.items():
        print(f"Host: {host}")
        for service in services:
            print(f"\tService: {service['service_name']}, Port: {service['port']}, Product: {service['product']}, Version: {service['version']}")
            for cve_entry in service['cves']:
                cve_id = cve_entry['id']
                cvss_score = cve_entry.get('cvss', 'N/A')
                print(f"\t\tCVE: {cve_id}, CVSS Score: {cvss_score}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 vuln.py <path_to_nmap_xml_file>")
        sys.exit(1)

    xml_file = sys.argv[1]  # Path to the XML file as a command-line argument
    nmap_data = parse_nmap_output(xml_file)

    results = {}
    for host in nmap_data:
        for service in host['services']:
            if 'version' and 'cpe' in service:
                cve_results = query_cve_search(service['cpe'])
                if cve_results:
                    service_data = {
                        'port': service.get('port'),
                        'service_name': service.get('service_name'),
                        'product': service.get('product'),
                        'version': service.get('version'),
                        'cves': cve_results
                    }
                    results[host['host']] = results.get(host['host'], []) + [service_data]

    output_file = save_results(xml_file, results)
    print(f"Results saved in {output_file}")

    # Displaying the results
    display_results(results)

if __name__ == "__main__":
    main()
