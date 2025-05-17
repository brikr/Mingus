import * as fs from 'fs';
import * as path from 'path';

const WAGO_API_BASE = 'https://data.wago.io';

interface WeakAuraInput {
  name: string;
  slug: string;
}

interface WeakAuraOutput {
  name: string;
  version: number;
  uid: string;
  data: string;
}

interface WagoData {
  name: string;
  codeURL: string
}

interface WagoCodeData {
  encoded: string;
  json: string;
  version: number;
}

async function fetchJSON<T = unknown>(url: string): Promise<T> {
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} for ${url}`);
  }
  return res.json();
}

async function main() {
  const inputFile = path.join(__dirname, 'weakauras.json');
  const outputFile = path.join(__dirname, '..', 'WeakAuras', 'WeakAurasImported.lua');

  if (!fs.existsSync(inputFile)) {
    console.error(`Missing ${inputFile}`);
    process.exit(1);
  }

  const input: WeakAuraInput[] = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));
  const output: WeakAuraOutput[] = [];

  for (const entry of input) {
    const { slug, name } = entry;
    console.log(`Fetching ${name} (${slug})...`);

    try {
      const { codeURL } = await fetchJSON<WagoData>(
        `${WAGO_API_BASE}/lookup/wago?id=${slug}`
      );

      const codeData = await fetchJSON<WagoCodeData>(`${WAGO_API_BASE}${codeURL}`);
      const { encoded, json, version } = codeData;

      const tableData = JSON.parse(json);
      const uid = tableData.d.uid;

      output.push({
        name,
        version,
        uid,
        data: encoded
      });
    } catch (err: any) {
      console.error(`Failed to fetch ${slug}: ${err.message}`);
    }
  }

  let lua = 'local _, Mingus = ...\n'
  lua += 'Mingus.wa = {\n';
  for (const aura of output) {
    lua += `  [${JSON.stringify(aura.name)}] = {\n`;
    lua += `    version = ${aura.version},\n`;
    lua += `    import = ${JSON.stringify(aura.data)},\n`;
    lua += `  },\n`;
  }
  lua += '}\n';

  fs.writeFileSync(outputFile, lua, 'utf-8');
  console.log(`Generated ${outputFile} with ${output.length} entries.`);
}

main();
