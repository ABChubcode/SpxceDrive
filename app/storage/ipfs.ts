export const ipfsUploadFile = async (file: File) => {
	var myHeaders = new Headers();
	myHeaders.append("x-api-key", "QN_ec36bc1e42ff4471861d96d7291f157b");

	var formdata = new FormData();
	formdata.append("Body", file);
	formdata.append("Key", file.name);
	formdata.append("ContentType", file.type);

	var requestOptions: RequestInit = {
	method: 'POST',
	headers: myHeaders,
	body: formdata,
	redirect: 'follow'
	};

	let response: Response | void = await fetch("https://api.quicknode.com/ipfs/rest/v1/s3/put-object", requestOptions)
	let obj: any = JSON.parse(await response.text())
	console.log(obj);

	return obj.requestid
} 


export const ipfsgetFile = async (requestID: string) => {
	console.log("RequestID in ipfs")
	var myHeaders = new Headers();
	myHeaders.append("x-api-key", "QN_ec36bc1e42ff4471861d96d7291f157b");

	var requestOptions: RequestInit = {
	method: 'GET',
	headers: myHeaders,
	redirect: 'follow'
	};

	let response: Response | void = await  fetch(`https://api.quicknode.com/ipfs/rest/v1/pinning/${requestID}`, requestOptions)
	console.log("Response : ", response);
	let obj: any = JSON.parse(await response.text())
	// console.log(obj);

	return obj
}

export const ipfsDownloadFile = async (cid: string, filename: string) => {
	const baseUrl = "https://spxcedrive-gateway.quicknode-ipfs.com/ipfs";

	let response: Response | void = await fetch(`${baseUrl}/${cid}`);

	 // Check if the fetch was successful
	 if (!response.ok) {
		throw new Error('Failed to fetch file');
	  }
  
	  // Read the response body as a blob
	  const fileBlob = await response.blob();
  
	  // Create a blob URL for the file
	  const blobUrl = window.URL.createObjectURL(fileBlob);
  
	  // Create a hidden anchor element
	  const a = document.createElement('a');
	  a.href = blobUrl;
	  a.download = filename;
  
	  // Append the anchor element to the document body
	  document.body.appendChild(a);
  
	  // Trigger a click event on the anchor element to initiate the download
	  a.click();
  
	  // Clean up
	  document.body.removeChild(a);
	  window.URL.revokeObjectURL(blobUrl);
  
	  console.log('File downloaded:', filename);
} 
