import { readdir } from 'fs/promises'
import { resolve } from 'path'

const getEntries = async (dirName: string, ext: string) => {
    let entries: { [key: string]: string } = {}
    const items = await readdir(dirName, { withFileTypes: true })

    for (const item of items) {
        if (item.isDirectory()) {
            entries = {
                ...entries,
                ...(await getEntries(`${dirName}/${item.name}`, ext)),
            }
        } else if (item.name.endsWith(ext)) {
            // entries.push(`${dirName}/${item.name}`)
            entries[`${dirName}/${item.name}`] = resolve(
                __dirname,
                `${dirName}/${item.name}`
            )
        }
    }

    return entries
}

export default getEntries
