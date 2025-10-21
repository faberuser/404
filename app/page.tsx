import Link from "next/link"

const pageHeading = process.env.NEXT_PUBLIC_PAGE_HEADING
    ? process.env.NEXT_PUBLIC_PAGE_HEADING
    : "404 Not Found"

const pageMessage = process.env.NEXT_PUBLIC_PAGE_MESSAGE
    ? process.env.NEXT_PUBLIC_PAGE_MESSAGE
    : "The page you are looking for does not exist."

const supportUrl = process.env.NEXT_PUBLIC_SUPPORT_URL
    ? process.env.NEXT_PUBLIC_SUPPORT_URL
    : null

export default function Home() {
    return (
        <div className="font-sans flex items-center justify-center min-h-screen p-8">
            <main className="flex flex-col items-center text-center gap-8">
                <div className="space-y-4">
                    <div
                        className="text-3xl font-semibold text-gray-800 dark:text-gray-100"
                        dangerouslySetInnerHTML={{ __html: pageHeading }}
                    />
                    <div
                        className="text-gray-600 dark:text-gray-400 text-lg"
                        dangerouslySetInnerHTML={{ __html: pageMessage }}
                    />
                </div>

                {supportUrl && (
                    <Link
                        className="rounded-full border border-solid border-black/[.08] dark:border-white/[.145] transition-colors flex items-center justify-center hover:bg-[#f2f2f2] dark:hover:bg-[#1a1a1a] hover:border-transparent font-medium text-sm sm:text-base h-12 px-6"
                        href={supportUrl}
                        target="_blank"
                        rel="noreferrer"
                    >
                        Contact Support
                    </Link>
                )}
            </main>
        </div>
    )
}
